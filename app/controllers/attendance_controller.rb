class AttendanceController < ApplicationController
  before_filter :current_ability
  before_filter -> { gon.clear }

  def dashboard
    if check_department_settings
      month = params[:month].present? ? params[:month].to_i : Date.today.month
      year = params[:year].present? ? params[:year].to_i : Date.today.year
      begin_of_month = Date.new(year, month)
      end_of_month = begin_of_month.end_of_month

      @attendances = current_department.attendances.includes(:employee).where(in_date: Date.today).order(id: :desc)
      @absent_employees = current_department.employees - @attendances.map(&:employee)

      employee_work_stat = Employee.working_hours_stat(current_department, begin_of_month, end_of_month)
      gon.graph_label = employee_work_stat[:employees]
      gon.graph_data = employee_work_stat[:work_hours]
      gon.graph_color = employee_work_stat[:colors]
    else
      redirect_to general_department_path(current_department), notice: 'Please setup your departments general settings first.'

    end
  end
end