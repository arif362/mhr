# == Schema Information
#
# Table name: payroll_salaries
#
#  id                 :integer          not null, primary key
#  employee_id        :integer
#  department_id      :integer
#  payment_method     :string(255)
#  addition_category  :text(65535)
#  bonus              :float(24)
#  total              :float(24)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  deduction_category :text(65535)
#  month              :integer
#  year               :integer
#  basic_salary       :float(24)
#  total_addition     :float(24)
#  total_deduction    :float(24)
#  is_confirmed       :boolean          default(TRUE)
#  from_combined      :boolean          default(FALSE)
#

module Payroll
  class Salary < Base
    STATES = {
        list: 'List',
        detail: 'Detail',
        summary: 'Summary'
    }
    serialize :addition_category, Hash
    serialize :deduction_category, Hash
    belongs_to :employee
    belongs_to :department
    has_one :advance_return, :class_name => 'Expenses::AdvanceReturn'

    def self.confirmed(month, year)
      self.where(month: month, year: year, is_confirmed: true)
    end

    def self.unconfirmed(month = nil, year = nil, department_id: nil)
      if month.present? && year.present? && department_id.present?
        self.where(month: month, year: year, is_confirmed: false, department_id: department_id)
      else
        self.where(is_confirmed: false)
      end
    end

    def self.process(department, employee, month, year)
      employee_status = Employee.get_monthly_status(department, employee, month, year)
      payroll_categories = employee.payroll_employee_categories.includes(:category)
      get_employee_salary(department, employee, employee_status, payroll_categories, month, year)
    end

    def self.get_employee_salary(department, employee, employee_status, payroll_categories, month, year)
      additions = Hash.new
      deductions = Hash.new
      total_days = Time.days_in_month(month, year)
      daily_rate = employee.daily_rate(total_days)
      start_date = Date.new(year, month)
      end_date = start_date.end_of_month
      hourly_rate = employee.hourly_rate(daily_rate, start_date, end_date)
      salary = self.new(basic_salary: employee.get_basic_salary, employee_id: employee.id, department_id: department.id, month: month, year: year, total_addition: employee.get_basic_salary, total_deduction: 0.0, total: 0.0)
      payroll_categories.each do |payroll_category|
        category = payroll_category.category
        if category.is_add
          key = category.name.parameterize('_')+'_amount'
          additions[key.to_sym] = category.is_percentage ? percentage_amount(salary.basic_salary, payroll_category.percentage) : payroll_category.amount
          salary.total_addition += additions[key.to_sym]
        else
          key = category.name.parameterize('_')+'_deduct'
          deductions[key.to_sym] = category.is_percentage ? percentage_amount(salary.basic_salary, payroll_category.percentage) : payroll_category.amount
          salary.total_deduction += deductions[key.to_sym]
        end
      end

      deductions[:unpaid_leave_days] = employee_status[:leaves_report][:unpaid_leave]
      deductions[:unpaid_leave_deduct] = amount_from_days(daily_rate, employee_status[:leaves_report][:unpaid_leave])
      salary.total_deduction += deductions[:unpaid_leave_deduct]

      deductions[:late_days] = employee_status[:attendance_report][:late_days]
      deductions[:late_time] = hour_from_second(employee_status[:attendance_report][:late_time])
      deductions[:late_time_deduct] = amount_from_hours(hourly_rate, hour_from_second(employee_status[:attendance_report][:late_time]))
      salary.total_deduction += deductions[:late_time_deduct]

      deductions[:less_worked_hours] = hour_from_second(employee_status[:attendance_report][:less_worked_hour])
      deductions[:less_work_deduct] = amount_from_hours(hourly_rate, hour_from_second(employee_status[:attendance_report][:less_worked_hour]))
      salary.total_deduction += deductions[:less_work_deduct]

      deductions[:absent_days] = employee_status[:absent_days]
      deductions[:absent_deduct] = amount_from_days(daily_rate, employee_status[:absent_days])
      salary.total_deduction += deductions[:absent_deduct]


      additions[:over_time] = hour_from_second(employee_status[:attendance_report][:over_time])
      additions[:over_time_amount] = amount_from_hours(hourly_rate, hour_from_second(employee_status[:attendance_report][:over_time]))
      salary.total_addition += additions[:over_time_amount]

      salary.addition_category = additions
      salary.deduction_category = deductions

      salary.total = salary.total_addition - salary.total_deduction

      salary
    end

    def self.percentage_amount(salary, percentage)
      ((salary.to_f * percentage.to_f) / 100.00).round(2)
    end

    def self.amount_from_days(per_day_rate, deduct_days)
      (per_day_rate.to_f * deduct_days.to_f).round(2)
    end

    def self.amount_from_hours(per_hour_rate, deduct_hours)
      (per_hour_rate.to_f * deduct_hours.to_f).round(2)
    end

    def self.hour_from_second(second)
      (second.to_f / 3600.00).round(2)
    end

    def self.get_payable_employees(employees, month, year)
      salaries = self.where(month: month, year: year).includes(:employee)
      employee_ids = salaries.map {|salary| salary.employee_id}
      employee_ids.present? ? employees.where('id NOT IN (?)', employee_ids) : employees
    end

    def self.get_payable_departments(company, month, year)

      departments = company.departments
      department_ids = departments.ids
      payable_departments = Array.new

      num_of_employees = Employee.where('invitation_token IS NULL and is_active = true', department_id: department_ids).group(:department_id).count(:id)
      num_of_salaries = Payroll::Salary.where(department_id: department_ids, month: month, year: year).group(:department_id).count(:id)

      departments.each do |department|
        setting = department.setting

        if setting.open_time.present? && setting.working_hours.present?
          if num_of_salaries[department.id].present?
            if num_of_salaries[department.id] < num_of_employees[department.id]
              payable_departments.push(department)
            end
          else
            payable_departments.push(department)
          end
          #payable_departments
        end
      end

      payable_departments
    end


    def self.dashboard_summary(department, year)
      salaries = department.payroll_salaries.where(year: year)
      gross = Array.new(12, 0)
      deduct = Array.new(12, 0)
      net = Array.new(12, 0)
      net_total = 0.0
      salaries.each do |salary|
        gross[salary.month - 1] += salary.basic_salary
        deduct[salary.month - 1] += salary.total_deduction
        net[salary.month - 1] += salary.total
        net_total += salary.total
      end
      {gross_salaries: gross, deduct_amounts: deduct, net_salaries: net, net_total: net_total}
    end

    def self.combined_salary(department_ids, combined_salary_month, combined_salary_year, date)
      if date.present?
        if date[:month] == ""
          payroll_salaries = Payroll::Salary.includes(:department).where(year: combined_salary_year, department_id: department_ids).group(:department_id).select('* ,department_id, SUM(total) as total_salary')
        else
          payroll_salaries = Payroll::Salary.includes(:department).where(month: combined_salary_month, year: combined_salary_year, department_id: department_ids).group(:department_id).select(' * ,department_id, SUM(total) as total_salary')
        end
      else
        payroll_salaries = Payroll::Salary.includes(:department).where(month: combined_salary_month, year: combined_salary_year, department_id: department_ids).group(:department_id).select('* ,department_id, SUM(total) as total_salary')
      end

      payroll_salaries
    end

    def self.unconfirmed_combined_salary(department_ids, combined_salary_month, combined_salary_year, date)
      if date.present?
        if date[:month] == ""
          unconfirmed_combined_salary = Payroll::Salary.where(department_id: department_ids, year: combined_salary_year, from_combined: true, is_confirmed: false).sum(:total)
        else
          unconfirmed_combined_salary = Payroll::Salary.where(department_id: department_ids, month:combined_salary_month, year: combined_salary_year, from_combined: true, is_confirmed: false).sum(:total)
        end
      else
        unconfirmed_combined_salary = Payroll::Salary.where(department_id: department_ids, month:combined_salary_month, year: combined_salary_year, from_combined: true, is_confirmed: false).sum(:total)
      end
      unconfirmed_combined_salary
    end

    # Callbacks

    after_create :send_email_notification

    private

    def send_email_notification
      # NotificationMailer.salary_receipt(self).deliver_now
    end

  end
end

