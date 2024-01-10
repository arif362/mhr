# == Schema Information
#
# Table name: employees
#
#  id                          :integer          not null, primary key
#  email                       :string(255)      default(""), not null
#  encrypted_password          :string(255)      default("")
#  reset_password_token        :string(255)
#  reset_password_sent_at      :datetime
#  remember_created_at         :datetime
#  sign_in_count               :integer          default(0), not null
#  current_sign_in_at          :datetime
#  last_sign_in_at             :datetime
#  current_sign_in_ip          :string(255)
#  last_sign_in_ip             :string(255)
#  confirmation_token          :string(255)
#  confirmed_at                :datetime
#  confirmation_sent_at        :datetime
#  unconfirmed_email           :string(255)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  first_name                  :string(255)
#  last_name                   :string(255)
#  note                        :text(65535)
#  location                    :string(255)
#  dob                         :date
#  address                     :text(65535)
#  gender                      :string(255)
#  image                       :string(255)
#  department_id               :integer
#  role                        :string(255)      default("staff")
#  invitation_token            :string(255)
#  invitation_created_at       :datetime
#  invitation_sent_at          :datetime
#  invitation_accepted_at      :datetime
#  invitation_limit            :integer
#  invited_by_id               :integer
#  invited_by_type             :string(255)
#  blood_group                 :string(255)
#  joining_date                :date
#  designation_id              :integer
#  basic_salary                :float(24)
#  mobile                      :string(255)
#  nid                         :string(255)
#  kin_name                    :string(255)
#  kin_contact                 :string(255)
#  is_active                   :boolean          default(TRUE)
#  deactivated_by              :integer
#  deactivate_date             :date
#  id_card_no                  :string(255)
#  employee_type               :string(255)
#  present_address             :string(255)
#  permanent_address           :string(255)
#  color                       :string(255)
#  slug                        :string(255)
#  kin_relationship            :string(255)
#  marital_status              :string(255)
#  nationality                 :string(255)
#  country                     :string(255)
#  attachment                  :string(255)
#  bank_account_number         :string(255)
#  bank_details                :text(65535)
#  previous_employment_history :string(255)
#  religion                    :string(255)
#

class Employee < ActiveRecord::Base
  extend FriendlyId
  friendly_id :employee_slug, use: [:slugged, :finders]

  ROLE = {
      admin: 'admin',
      stuff: 'stuff'
  }

  TYPE = {
      full_time: 'Full Time',
      part_time: 'Part Time',
      remote: 'Remote',
      contractual: 'Contractual',
      full_time_probation: 'Full Time(Probation)',
      intern: 'Intern'
  }
  mount_uploader :image, ImageUploader
  mount_uploader :attachment, FileUploader

  belongs_to :department
  belongs_to :designation

  has_one :access_right, dependent: :destroy
  accepts_nested_attributes_for :access_right
  has_one :company
  has_one :provident_fund_account, :class_name => 'ProvidentFund::Account', dependent: :destroy

  has_many :attendances, :class_name => 'Attendance::Attendance', dependent: :destroy
  has_many :leave_applications, :class_name => 'Leave::Application', dependent: :destroy
  has_many :expenses, :class_name => 'Expenses::Expense', foreign_key: :created_by_id, dependent: :destroy
  has_many :expenses, :class_name => 'Expenses::Expense', foreign_key: :approved_by_id, dependent: :destroy
  has_many :advances, :class_name => 'Employees::Advance', dependent: :destroy
  has_many :remarks, :class_name => 'Remark', foreign_key: :remarked_by_id, dependent: :destroy
  has_many :payroll_employee_categories, :class_name => 'Payroll::EmployeeCategory', dependent: :destroy
  has_many :payroll_categories, :class_name => 'Payroll::Category', through: :payroll_employee_categories, source: :category
  has_many :payroll_salaries, :class_name => 'Payroll::Salary', dependent: :destroy
  has_many :payroll_increments, :class_name => 'Payroll::Increment', dependent: :destroy
  has_many :advance_returns, :class_name => 'Employees::AdvanceReturn', dependent: :destroy
  has_many :bonus_payments, class_name: 'Payroll::BonusPayment', dependent: :destroy
  has_many :community_posts, :class_name => 'Community::Post', foreign_key: :author_id, dependent: :destroy
  has_many :community_comments, :class_name => 'Community::Comment', foreign_key: :author_id, dependent: :destroy
  has_many :daily_progress_tasks, :class_name => 'DailyProgress::Task', dependent: :destroy

  accepts_nested_attributes_for :payroll_categories
  accepts_nested_attributes_for :payroll_employee_categories, reject_if: proc { |attributes| attributes[:category_id].blank? || (attributes[:amount].present? ? attributes[:amount].blank? : attributes[:percentage].blank?) }


  devise :invitable, :database_authenticatable, :registerable, #:confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessor :accept_tac

  before_create :assign_color_code

  scope :active, -> { where(is_active: true) }

  def full_name
    if first_name && last_name
      first_name + ' ' + last_name
      # else
      #   first_name ? first_name : last_name
    end
  end

  def full_address
    if present_address.present?
      present_address
    elsif permanent_address.present?
      permanent_address
    elsif location.present?
      location
    else
      ''
    end
  end

  def get_basic_salary
    basic_salary.present? ? basic_salary : 0.00
  end

  def change_employee_salary(history)
    if self.basic_salary.present?
      salary = self.basic_salary
    else
      salary = 0
    end
    self.basic_salary = salary + history.increment_amount
    if self.save
      history.is_active = true
      history.save
    end
  end

  def assign_color_code
    self.color = '#' + SecureRandom.hex(3)
  end

  def super_admin?
    role == Employee::ROLE[:admin]
  end

  def self.prepare_company(resource, company_params)
    if company_params.present?
      company = resource.build_company(company_params)
      company.next_path = AppSettings::REGISTRATION_STEPS[:feature_selection]
      if company.save
        department = company.departments.build(name: 'Head Office', email: company.contact_email, mobile: company.mobile, description: 'Head Office', address: company.address, city: company.city, state: company.state, zip_code: company.zip_code, country: company.country)
        if department.save
          resource.department_id = department.id
          resource.role = Employee::ROLE[:admin]
          resource.save
           resource.company_welcome_email
          # resource.company_created_info(company)
        end
      end
    end
  end

  def self.get_monthly_status(current_department, employee, month, year)
    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month
    dayoffs_report = Attendance::DayOff.day_off_report(current_department, start_date, end_date)
    leaves_report = Leave::Application.leave_report(current_department, employee, start_date, end_date)
    should_worked = employee_should_worked(current_department, dayoffs_report, leaves_report, start_date, end_date)
    attendance_report = Attendance::Attendance.attendance_report(current_department, employee, start_date, end_date)
    office_days = employee_office_days(dayoffs_report, start_date, end_date)
    absent_days = employee_absent_days(office_days, leaves_report, attendance_report)
    status = {
        dayoffs_report: dayoffs_report,
        leaves_report: leaves_report,
        attendance_report: attendance_report,
        should_worked: should_worked,
        office_days: office_days,
        absent_days: absent_days
    }
    status
  end

  def self.search(department, params)
    all_employee = department.employees.where('invitation_token IS NULL').includes(:designation)
    if params[:q].present?
      all_employee = all_employee.where("CONCAT(IFNULL(first_name,''),' ',IFNULL(last_name,'')) like :q or email like :q or mobile like :q or id_card_no like :q or employee_type like :q", q: "%#{params[:q]}%")
    end
    all_employee.paginate(:page => params[:page], :per_page => 10)
  end

  def self.employee_should_worked(current_department, dayoffs_report, leaves_report, start_date, end_date)
    monthly_working_hour = current_department.monthly_working_hours(current_department.setting, start_date, end_date)
    (monthly_working_hour * 60 * 60) - (((dayoffs_report[:weekend_days] + dayoffs_report[:holidays]) * 8 * 60 * 60) + dayoffs_report[:custom_holiday_hours].to_i + (leaves_report[:paid_leave] * 8 * 60 * 60))
  end

  def self.employee_office_days(dayoffs_report, start_date, end_date)
    month_days = number_of_days(start_date, end_date)
    month_days - (dayoffs_report[:weekend_days] + dayoffs_report[:holidays])
  end

  def self.employee_absent_days(office_days, leaves_report, attendance_report)
    office_days - (attendance_report[:present_days] + leaves_report[:taken_leave])
  end

  def self.number_of_days(start_date, end_date)
    ((end_date - start_date).to_i) + 1
  end

  def amount_from_percentage(percentage)
    ((get_basic_salary.to_f * percentage.to_f) / 100.00).round(2)
  end

  def daily_rate(days, salary = nil)
    ((salary.present? ? salary : self.get_basic_salary).to_f / days.to_f).round(2)
  end

  def hourly_rate(per_day_rate, start_date, end_date)
    emp_dept = self.department
    monthly_hour = emp_dept.monthly_working_hours(emp_dept.setting, start_date, end_date)
    p '*****************************************************'
    p monthly_hour
    p '*****************************************************'
    days = (end_date - start_date).to_i + 1
    hour_avg = monthly_hour.to_f / days.to_f

    (per_day_rate.to_f / hour_avg).round(2)
  end

  def self.working_hours_stat(department, from, to)
    employee_work_hours = department.attendances.where(in_date: from..to).order('employee_id asc').group('employee_id').sum(:duration)
    work_hours = employee_work_hours.values.collect { |dur| (dur.to_f / 3600).round }
    employees = self.where(id: employee_work_hours.keys).order('id asc').map(&:first_name)
    colors = self.where(id: employee_work_hours.keys).map(&:color)
    {work_hours: work_hours, employees: employees, colors: colors, total: employees.length}
  end

  def on_leave(date)
    Leave::Day.where(day: date.to_date, is_approved: true).includes(:leave_application).where('leave_applications.employee_id = ? AND leave_applications.is_approved = ?', self.id, true).references(:leave_applications).first
  end

  def short_name
    short_name = self.full_name.split.map(&:first).join
    short_name.upcase
  end

  def sidebar_menu_generator
    {
        title: 'Employee Profile',
        tooltip: 'Employee Profile',
        menus: [
            {title: 'Personal Info', url: "/employees/#{self.slug}", icon: 'fa-info-circle', class: 'information sidebar-menu-active', tooltip: 'Personal Informations'},
            {title: 'Attendance', url: "/employees/#{self.slug}/attendances?no_modal=true", icon: 'fa-calendar-check-o', class: 'attendance', tooltip: 'Employee\'s Attendance'},
            {title: 'Leave', url: "/leave/applications/leave_status?employee_id=#{ self.slug }", icon: 'fa-th-large', class: 'leave', tooltip: 'Employee\'s Leave Status'},
            {title: 'Settings', url: "/employees/#{self.slug}/settings", icon: 'fa-cog', class: 'employee-settings', tooltip: 'Account Settings'},
        ]
    }
  end

  def next_path
    if self.department.present?
      self.department.company.next_path.present? ? self.department.company.next_path : nil
    else
      AppSettings::REGISTRATION_STEPS[:registration]
    end
  end


  def self.import(spreadsheet, header, department)
    # spreadsheet = Roo::Spreadsheet.open(file.path)
    # header = spreadsheet.row(1)
    hash = []
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      employee = Employee.find_by(email: row['Email'])
      if employee.present?
        hash.push({row: i, email: row['Email'], status: false, message: " '#{row['Email']}' already exists."})
      else
        employee = Employee.new(email: row['Email'], department_id: department.id)
        employee.first_name = row['FirstName']
        employee.last_name = row['LastName']
        employee.email = row['Email']
        employee.id_card_no = row['EmployeeId']
        designation = department.designations.find_or_create_by(name: row['Designation'])
        employee.designation_id = designation.id
        employee.basic_salary = row['BasicSalary']
        employee.joining_date = row['JoiningDate'].strftime('%Y-%m-%d')
        employee.nid = row['NationalId']
        if row['Country'].present?
          country = ISO3166::Country.find_by_name(row['Country'])
          if country.present?
            employee.country = country[0]
          end
        end
        employee.blood_group = row['BloodGroup']
        employee.dob = row['Dateofbirth'].strftime('%Y-%m-%d')
        employee.mobile = row['Mobile']
        employee.present_address = row['PresentAddress']
        employee.permanent_address = row['PermanentAddress']
        employee.kin_name = row['KinName']
        employee.bank_account_number = row['BankAccountNumber']
        employee.bank_details = row['BankDetails']
        employee.previous_employment_history = row['PriviousEmploymentHistory']
        employee.nationality = row['Nationality']
        employee.religion = row['Religion']
        employee.kin_contact = row['KinContact']
        employee.gender = row['Gender'].capitalize
        employee.marital_status = row['MaritalStatus'].capitalize
        employee.password = '123456789'
        begin
          employee.save
          employee.send_reset_password_instructions
            # hash.push({ row: i, email: row['Email'], status: false, message: "Employee Successfully imported."  })
        rescue => e
          hash.push({row: i, email: row['Email'], status: false, message: e.message})
        end
      end
    end
    hash
  end

  def employee_slug
    employees = Employee.all.where(first_name: first_name, last_name: last_name)
    if employees.present?
      first_name + ' ' + last_name + '-' + employees.count.to_s
    else
      first_name + ' ' + last_name
    end
  end

  def remove_empty_payroll_category(payroll_employee_category_params)
    payroll_employee_category_params.each do |key, attributes|
      if attributes[:category_id].present?
        if attributes.key?('amount') && attributes[:amount].blank?
          self.remove_payroll_category(attributes[:category_id])
        elsif attributes.key?('percentage') && attributes[:percentage].blank?
          self.remove_payroll_category(attributes[:category_id])
        end
      end
    end
  end

  def remove_payroll_category(category_id)
    employee_payroll_categories = self.payroll_employee_categories.where(category_id: category_id)
    if employee_payroll_categories.present?
      employee_payroll_categories.first.destroy
    end
  end

  def company_welcome_email
    NotificationMailer.company_welcome(self).deliver_now
  end

  def company_created_info(company)
    NotificationMailer.company_created_notice(self, company).deliver_now
  end

  def task_of(date)
    daily_progress_tasks.where(date: date)
  end

  def progress_report(start_date, end_date)
    report = {}
    (start_date..end_date).each do |date|
      report[date.to_s] = self.daily_progress_tasks.where(date: date)
    end
    report
  end

  def progress_reports

  end

end
