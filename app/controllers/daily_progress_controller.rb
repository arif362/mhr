class DailyProgressController < ApplicationController
  before_filter :current_ability
  def dashboard
    @date = params[:date] || Date.today.to_s
    @next_day = Date.parse(@date) + 1
    @prev_day = Date.parse(@date) - 1
    @progress = DailyProgress::Task.where(date: @date).group_by(&:employee)
  end

  def my_report
    start_date = Date.today.beginning_of_month
    end_date = Date.today
    if params[:daterange].present?
      date_range = params[:daterange].split('To')
      start_date = Date.parse(date_range.first)
      end_date = Date.parse(date_range.last)
    end
    @my_progress_reports = current_employee.progress_report(start_date, end_date)
  end

  def progress_reports
    start_date = Date.today.beginning_of_month
    end_date = Date.today
    if params[:daterange].present?
      date_range = params[:daterange].split('To')
      start_date = Date.parse(date_range.first)
      end_date = Date.parse(date_range.last)
    end
    @my_progress_reports = current_employee.progress_report(start_date, end_date)
    @employee_1 = current_employee.progress_report(start_date, end_date)
    @employees = Employee.all.map(&:full_name)
    employees = Employee.all
    @employees_progress = get_employees_progress(employees, start_date, end_date)
    @colors = get_random_colors(@employees.size)
  end

  def compare_progress
    start_date = Date.today.beginning_of_month
    end_date = Date.today
    if params[:daterange].present?
      date_range = params[:daterange].split('To')
      start_date = Date.parse(date_range.first)
      end_date = Date.parse(date_range.last)
    end

    if params[:employee_1].present?
      employee_1 = Employee.where(id: params[:employee_1])
      @employee_1 = employee_1.map(&:full_name)
    end

    if params[:employee_2].present?
      employee_2 = Employee.where(id: params[:employee_2])
      @employee_2 = employee_2.map(&:full_name)
    end

    @employee_progress_1 = get_progress_data(employee_1, start_date, end_date)
    @employee_progress_2 = get_progress_data(employee_2, start_date, end_date)
    @color_1 = get_colors(@employee_1)
    @color_2 = get_colors(@employee_2)
  end

  private

  def get_progress_data(employees, start_date, end_date)
    @employees_ = get_employees_progress(employees, start_date, end_date)
  end
  def get_colors(employees)
    get_random_colors(employees.size)
  end

end
