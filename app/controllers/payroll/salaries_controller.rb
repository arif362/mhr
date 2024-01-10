module Payroll
  class SalariesController < BaseController
    before_filter :current_ability
    before_action :set_salary, only: [:show, :edit, :update, :destroy, :update_salary_status]

    def index
      if check_department_settings

        @end_date = Date.today.beginning_of_month - 1.day
        if params[:date].present?
          @end_date = Date.new(params[:date][:year].to_i, params[:date][:month].to_i).end_of_month
        end
        @start_date = @end_date.beginning_of_month
        @salary_month = @end_date.month
        @salary_year = @end_date.year

        if params[:employee_id].present?
          @employee = Employee.find_by_id(params[:employee_id])
          @salaries = @employee.payroll_salaries
          @salary = get_salary_of_month(@salaries, @salary_month, @salary_year)

          if @salary.new_record?
            @employee_status = Employee.get_monthly_status(current_department, @employee, @salary_month, @salary_year)
            @payroll_employee_categories = @employee.payroll_employee_categories.includes(:category)
            @total_addition = @employee.get_basic_salary
            @total_deduct = 0.0
            @total_days = (@end_date - @start_date).to_i + 1
            @daily_rate = @employee.daily_rate(@total_days)
            @hourly_rate = @employee.hourly_rate(@daily_rate, @start_date, @end_date)
          end

        else
          @salaries = current_department.payroll_salaries.confirmed(@salary_month, @salary_year)
        end
        unconfirmed_salaries = current_department.payroll_salaries.unconfirmed
        @is_unconfirmed = unconfirmed_salaries.present?
        pending_jobs = Delayed::Job.where("handler LIKE '%SalaryCreatedJob%'").where(source_id: current_department.id)
        @is_pending = pending_jobs.present?
      else
        redirect_to general_department_path(current_department), notice: 'Please setup your departments general settings first.'
      end

      respond_to do |format|
        format.html {}
        format.js {}
      end
    end

    def show
      @employee = @salary.employee
      respond_to do |format|
        format.js
      end
    end

    def payslip
      @salary = Payroll::Salary.find_by_id(params[:salary_id])
      @employee = @salary.employee
      @right_border = ' '
      @left_border = ' '
      if @salary.addition_category.size + 1 > @salary.deduction_category.size
        @right_border = 'right-border'
      else
        @left_border = 'left-border'
      end
      respond_to do |format|
        format.html
        format.pdf do
          render pdf: 'Payslip', layout: 'pdf', disposition: 'attachment', template: 'payroll/salaries/payslip_pdf.html.erb', encoding: 'utf-8'
        end
      end
    end

    def new
      @salary = Payroll::Salary.new
    end

    def create
      @salary = current_department.payroll_salaries.build(salary_params)
      respond_to do |format|
        if @salary.save
          @employee = @salary.employee
          format.js {}
        end
      end
    end

    def edit
      @salary_month = @salary.month
      @salary_year = @salary.year
      @employee = @salary.employee
      respond_to do |format|
        format.html
        format.js
      end
    end

    def update
      respond_to do |format|
        @salary.update(salary_params)
        @employee = @salary.employee
        format.html {redirect_to unconfirmed_salaries_payroll_salaries_path, notice: 'Salary successfully updated.'}
        format.js
      end
    end

    def destroy
      respond_to do |format|
        @salary.destroy
        format.js
      end
    end

    def process_salary
      if params[:date].present?
        @salary_month = params[:date][:month].to_i
        @salary_year = params[:date][:year].to_i
      else
        @salary_month = start_of_prev_month.month
        @salary_year = Date.today.year
      end
      @employees = Payroll::Salary.get_payable_employees(current_active_employees, @salary_month, @salary_year)
    end

    def process_all
      Delayed::Job.enqueue(SalaryCreatedJob.new(current_department, params[:date][:year].to_i, params[:date][:month].to_i, params[:employee_ids]))
      redirect_to payroll_salaries_path, notice: 'Salary is processing'
    end

    def payable_employees
      @salary_month = params[:month].to_i
      @salary_year = params[:year].to_i
      @employees = Payroll::Salary.get_payable_employees(current_active_employees, @salary_month, @salary_year)
      respond_to do |format|
        format.js
      end
    end

    def unconfirmed_salaries
      @salaries = current_department.payroll_salaries.unconfirmed
    end

    def confirm
      @salaries = current_department.payroll_salaries.where(id: params[:salary_ids])
      if @salaries.present?
        @salaries.update_all(is_confirmed: true)
      end
      respond_to do |format|
        format.html {redirect_to payroll_salaries_path, notice: 'Salaries successfully confirmed.'}
        format.pdf do
          render pdf: 'Bank Payslip', layout: 'pdf', template: 'payroll/salaries/salaries_pdf.html.erb', encoding: 'utf-8'
        end
      end
    end

    def update_salary_status
      if @salary.present?
        if @salary.is_confirmed.present?
          @salary.update(is_confirmed: false)
        else
          @salary.update(is_confirmed: true)
        end
      end
      respond_to do |format|
        @employee = @salary.employee
        @salaries = @employee.payroll_salaries
        @unconfirmed_salaries = current_department.payroll_salaries.unconfirmed
        format.js {}
      end
    end

    def monthly_sheet
      if params[:date].present?
        @month = params[:date][:month].to_i
        @year = params[:date][:year].to_i
      else
        @month = start_of_prev_month.month
        @year = start_of_prev_month.year
      end
      @salaries = current_department.payroll_salaries.where(month: @month, year: @year).includes(:employee)
      respond_to do |format|
        format.html
        format.xls do
          render xls: 'Monthly Salary Sheet', layout: 'excel', template: 'payroll/salaries/monthly_sheet_xls_docx.html.erb', encoding: 'utf-8'
        end
        format.pdf do
          render pdf: 'Monthly Salary Sheet', layout: 'pdf', template: 'payroll/salaries/monthly_sheet_pdf.html.erb', encoding: 'utf-8'
        end
        format.docx do
          render docx: 'Monthly Salary Sheet', layout: 'document', template: 'payroll/salaries/monthly_sheet_xls_docx.html.erb', encoding: 'utf-8'
        end
      end

    end

    def combined_salary_report
      if check_department_settings
        if params[:date].present?
          if params[:date][:month] == ""
            start_date = Date.new(params[:date][:year].to_i)
            end_date = start_date.end_of_year
            @combined_salary_year = end_date.year
          else
            start_date = Date.new(params[:date][:year].to_i, params[:date][:month].to_i)
            end_date = start_date.end_of_month
            @combined_salary_month = end_date.month
            @combined_salary_year = end_date.year
          end
        else
          start_date = Date.today.beginning_of_month
        end

        unless params[:date].present?
          end_date = start_date.end_of_month
          @combined_salary_month = end_date.month
          @combined_salary_year = end_date.year
        end

        departments = current_company.departments
        department_ids = departments.ids

        @payroll_salaries =  Payroll::Salary.combined_salary(department_ids, @combined_salary_month, @combined_salary_year, params[:date])
        @unconfirmed_salaries = Payroll::Salary.unconfirmed_combined_salary(department_ids, @combined_salary_month, @combined_salary_year, params[:date])
        @pending_jobs = Delayed::Job.where("handler LIKE '%CombinedSalaryCreatedJob%'").where(source_id: current_company.id)
      else
        redirect_to general_department_path(current_department), notice: 'Please setup your departments general settings first.'
      end
      respond_to do |format|
        format.html
        format.js
        format.pdf do
          render pdf: 'Combined_salary', layout: 'pdf', template: 'payroll/salaries/combined_salary_pdf.html.erb', encoding: 'utf-8'
        end
        format.xls do
          render xls: 'Combined_salary', layout: 'excel', template: 'payroll/salaries/combined_salary_xls.html.erb', encoding: 'utf-8'
        end
        format.docx do
          render docx: 'Combined_salary', layout: 'document', template: 'payroll/salaries/combined_salary_xls.html.erb', encoding: 'utf-8'
        end
      end
    end

    def department_unconfirmed_salaries
      department_ids = current_company.departments.ids
      @salaries = Payroll::Salary.includes(:department).where(department_id: department_ids, is_confirmed: false).group(:department_id).select('department_id, SUM(total) as total_salary')
    end

    def confirm_departments
      if params[:department_ids].present?

        selected_departments = current_company.departments.includes(:payroll_salaries).where(id: params[:department_ids])

        selected_departments.each do |department|
          salaries = department.payroll_salaries.where(from_combined: true, is_confirmed: false)
          if salaries.present?
            salaries.update_all(is_confirmed: true)
          end
        end

      end

      respond_to do |format|
        format.html {redirect_to combined_salary_report_payroll_salaries_path, notice: 'Salaries successfully confirmed.'}
        format.pdf do
          render pdf: 'Bank Payslip', layout: 'pdf', template: 'payroll/salaries/department_confirm_salaries_pdf.html.erb', encoding: 'utf-8'
        end
      end

    end

    def process_combined_salary
      if params[:date].present?
        @combined_salary_month = params[:date][:month].to_i
        @combined_salary_year = params[:date][:year].to_i
      else
        @combined_salary_month = start_of_prev_month.month
        @combined_salary_year = Date.today.year
      end
      @departments = Payroll::Salary.get_payable_departments(current_company, @combined_salary_month, @combined_salary_year)
    end

    def payable_departments
      if params[:date].present?
        @combined_salary_month = params[:date][:month].to_i
        @combined_salary_year = params[:date][:year].to_i
      else
        @combined_salary_month = start_of_prev_month.month
        @combined_salary_year = Date.today.year
      end

      @departments = Payroll::Salary.get_payable_departments(current_company, @combined_salary_month, @combined_salary_year)
      respond_to do |format|
        format.js
      end
    end

    def process_all_combined_salary
      Delayed::Job.enqueue(CombinedSalaryCreatedJob.new(current_company, params[:date][:year].to_i, params[:date][:month].to_i, params[:department_ids]))
      redirect_to combined_salary_report_payroll_salaries_path, notice: 'Salary is processing'
    end

    def count_worked_day(month)

    end

    private

    def set_salary
      @salary = current_department.payroll_salaries.find_by_id(params[:id])
    end

    def salary_params
      params.require(:payroll_salary).permit!
    end

    def get_salary_of_month(salaries, month, year)
      salary = salaries.where(month: month, year: year)
      salary.present? ? salary.first : Payroll::Salary.new
    end
  end
end
