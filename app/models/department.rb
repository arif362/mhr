# == Schema Information
#
# Table name: departments
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text(65535)
#  image       :string(255)
#  company_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  address     :text(65535)
#  slug        :string(255)
#  city        :string(255)
#  state       :string(255)
#  zip_code    :string(255)
#  country     :string(255)
#  email       :string(255)
#  mobile      :string(255)
#

class Department < ActiveRecord::Base

  extend FriendlyId
  friendly_id :department_slug, use: [:slugged, :finders]

  belongs_to :company
  has_one :setting, dependent: :destroy

  has_many :employees, dependent: :destroy
  has_many :attendances, :class_name => 'Attendance::Attendance', dependent: :destroy
  has_many :designations, dependent: :destroy
  has_many :day_offs, class_name: 'Attendance::DayOff', dependent: :destroy
  has_many :leave_applications, :class_name => 'Leave::Application', dependent: :destroy
  has_many :leave_categories, :class_name => 'Leave::Category', dependent: :destroy
  has_many :expenses_categories, :class_name => 'Expenses::Category', dependent: :destroy
  has_many :expenses_expenses, :class_name => 'Expenses::Expense', dependent: :destroy
  has_many :advances, :class_name => 'Employees::Advance', dependent: :destroy
  has_many :payroll_categories, :class_name => 'Payroll::Category', dependent: :destroy
  has_many :payroll_increments, :class_name => 'Payroll::Increment', dependent: :destroy
  has_many :payroll_salaries, :class_name => 'Payroll::Salary', dependent: :destroy
  has_many :advance_returns, :class_name => 'Employees::AdvanceReturn', dependent: :destroy
  has_many :bonus_categories, :class_name => 'Payroll::BonusCategory', dependent: :destroy
  has_many :bonus_payments, :class_name => 'Payroll::BonusPayment', dependent: :destroy
  has_many :provident_fund_rules, :class_name => 'ProvidentFund::Rule', dependent: :destroy
  has_many :provident_fund_accounts, :class_name => 'ProvidentFund::Account', dependent: :destroy
  has_many :provident_fund_investments, :class_name => 'ProvidentFund::Investment', dependent: :destroy
  has_many :provident_fund_loans, :class_name => 'ProvidentFund::Loan', dependent: :destroy
  has_many :provident_fund_loan_returns, :class_name => 'ProvidentFund::LoanReturn', dependent: :destroy
  has_many :expenses_budgets, :class_name => 'Expenses::Budget', dependent: :destroy
  has_many :leave_category_years, :class_name => 'Leave::CategoryYear', dependent: :destroy
  has_many :bank_accounts, :class_name => 'Bank::Account', dependent: :destroy
  has_many :provident_fund_transactions, :class_name => 'ProvidentFund::Transaction'
  has_many :changed_settings
  has_many :clients, class_name: 'Billing::Client', foreign_key: 'department_id'
  has_many :invoices, class_name: 'Billing::Invoice', foreign_key: 'department_id'

  SWITCH_ACTIONS = {
      show: 'show',
      employee: 'employee',
      designation: 'designation',
      leave: 'leave',
      budget: 'budget',
      general: 'general',
      attendance: 'attendance'
  }


  mount_uploader :image, LogoUploader

  validates_presence_of :name
  validates_uniqueness_of :name, scope: :company_id

  after_create :setting_create

  def year
    self.created_at.present? ? self.created_at.strftime('%Y').to_i : Date.today.year
  end


  def events
    day_offs = self.day_offs.order(date: :asc) #.where(year: Date.today.year)
    day_offs.present? ? day_offs.collect { |day_off| {id: day_off.id, title: day_off.title, start: day_off.date.strftime('%Y-%m-%d'), allDayDefault: true} } : []
  end

  def sidebar_menu_generator
    {
        title: 'Department Settings',
        tooltip: 'Department Settings',
        menus: [
            {title: 'Information', url: "/departments/#{self.slug}", icon: 'fa-info-circle', class: 'information sidebar-menu-active', tooltip: 'Information'},
            {title: 'General Settings', url: "/departments/#{self.slug}/settings/general", icon: 'fa-cog', class: 'general', tooltip: 'General Settings'},
            {title: 'Designation', url: "/departments/#{self.slug}/settings/designation", icon: 'fa-id-badge', class: 'designation', tooltip: 'Designations'},
            {title: 'Employees', url: "/departments/#{self.slug}/settings/employee", icon: 'fa-user-circle', class: 'employee', tooltip: 'Employees'},
            {title: 'Leave Categories', url: "/departments/#{self.slug}/settings/leave", icon: 'fa-th-large', class: 'leave', tooltip: 'Leave Categories'},
            {title: 'Expense Budget', url: "/departments/#{self.slug}/settings/budget", icon: 'fa-th-large', class: 'budget', tooltip: 'Expense Budget'},
            {title: 'Holiday Calender', url: "/departments/#{self.slug}/settings/attendance", icon: 'fa-calendar-check-o', class: 'attendance', tooltip: 'Holiday Calender'}

        ]
    }
  end

  def department_slug
    departments = Department.where(name: name)
    if departments.present?
      company.name + '_' + name + '_' + departments.count.to_s
    else
      company.name + '_' + name
    end
  end

  def active_employees(date = nil)
    if date.present?
      employees.where('is_active = ? OR deactivate_date > ?', true, date)
    else
      employees.where('is_active = ?', true)
    end
  end

  def action_path(action)
    if action == 'show'
      "/departments/#{self.id}"
    else
      "/departments/#{self.id}/settings/#{SWITCH_ACTIONS[action.to_sym]}"
    end
  end

  def get_settings(date)
    ch_settings = self.changed_settings.where('from_date <= ? AND to_date >= ?', date, date)
    ch_settings.present? ? ch_settings.first : self.setting
  end

  def currency
    cur = setting.currency || 'USD'
    p Money::Currency.new(cur)
  end

  def get_settings_data(settings, start_date, end_date)
    dept_settings = {}

    (start_date..end_date).each do |date|
      dept_settings[date.day] = {
          open_time: settings.open_time,
          working_hours: settings.working_hours
      }
    end

    ad_settings = self.changed_settings.where('(from_date <= ? AND to_date >= ?) OR (from_date >= ? AND to_date <= ?) OR (to_date >= ? AND from_date <= ?)', start_date, start_date, start_date, end_date, end_date, end_date)

    ad_settings.each do |ad_setting|
      from_date = ad_setting.from_date
      to_date = ad_setting.to_date

      init_date = from_date > start_date ? from_date : start_date
      last_date = to_date < end_date ? to_date : end_date

      (init_date..last_date).each do |date|
        if dept_settings[date.day].present?
          dept_settings[date.day][:open_time] = ad_setting.open_time
          dept_settings[date.day][:working_hours] = ad_setting.working_hours
        end
      end

    end

    dept_settings
  end

  def monthly_working_hours(settings, start_date, end_date)
    working_hours = settings.working_hours.present? ? settings.working_hours : 0.0
    total_hour = working_hours * ((end_date - start_date).to_i + 1).to_f
    p total_hour

    ad_settings = self.changed_settings.where('(from_date <= ? AND to_date >= ?) OR (from_date >= ? AND to_date <= ?) OR (to_date >= ? AND from_date <= ?)', start_date, start_date, start_date, end_date, end_date, end_date)
    ad_settings.each do |ad_setting|
      p ad_setting.from_date
      p start_date
      p ad_setting.to_date
      p end_date
      init_date = ad_setting.from_date > start_date ? ad_setting.from_date : start_date
      last_date = ad_setting.to_date < end_date ? ad_setting.to_date : end_date

      days = (last_date - init_date).to_i + 1
      p days
      total_hour -= (working_hours * days.to_f)
      p total_hour
      total_hour += (ad_setting.working_hours * days.to_f)
      p total_hour
    end

    total_hour
  end

  private

  def setting_create
    self.build_setting.save
  end
end
