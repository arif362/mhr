module  Payroll
  module SalariesHelper

    def active_employees(month, year)
      date = Date.new(year, month, 1)
      current_department.employees.where('is_active = ? OR deactivate_date > ?', true, date).where('invitation_token IS NULL')
    end

    def is_salary_initialized(employee, month, year)
      salary = employee.payroll_salaries.where(month: month, year: year)
      salary.present?
    end

    def amount_from_days(per_day_rate, deduct_days)
      # result = per_day_rate.to_f * deduct_days.to_f
      # number_with_precision(result, precision: 2)
      (per_day_rate.to_f * deduct_days.to_f).round(2)
    end

    def amount_from_hours(per_hour_rate, deduct_hours)
      # result = per_hour_rate.to_f * deduct_hours.to_f
      # number_with_precision(result, precision: 2)
      (per_hour_rate.to_f * deduct_hours.to_f).round(2)
    end

    def count_worked_day(salary)
      total_absent =salary.deduction_category[:absent_days].to_i
      total_days= Time.days_in_month(salary.month , salary.year)
      days = total_days-total_absent
    end
  end
end