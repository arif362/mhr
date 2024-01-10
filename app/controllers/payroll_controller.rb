class PayrollController < ApplicationController
  before_filter :current_ability

  def dashboard
    @prev_month_date = start_of_prev_month
    @summary = Payroll::Salary.dashboard_summary(current_department, Date.today.year)
    @last_salaries = current_department.payroll_salaries.where(month: @prev_month_date.month).includes(:employee)
  end

  def summary
    @summary = Payroll::Salary.dashboard_summary(current_department, params[:date][:year].to_i)
    respond_to do |format|
      format.js
    end
  end
end
