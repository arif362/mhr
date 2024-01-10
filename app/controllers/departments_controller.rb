class DepartmentsController < ApplicationController
  before_filter :current_ability
  before_action :set_department, only: [:edit, :update, :destroy, :show, :employee, :leave, :attendance, :general, :budget, :designation, :all_settings]

  def index
    @departments = current_department.company.departments
    respond_to do |format|
      format.js
      format.xls
      format.pdf do
        render pdf: 'report', layout: 'pdf', template: 'departments/department_list_pdf.html.erb', encoding: 'utf-8'
      end
      format.docx do
        render docx: 'report', template: 'departments/index.docx.erb', encoding: 'utf-8'
      end
    end
  end

  def new
    @department = Department.new(company_id: current_company.id)
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def create
    @department = current_company.departments.build(department_params)
    respond_to do |format|
      if @department.save
        format.html { redirect_to all_settings_department_path(@department), success: 'Department was successfully created' }
        format.json { render json: @department, status: :ok }
        format.js
      else
        format.html { render :new, danger: "Department couldn't be created" }
        format.json { render json: @department.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def show
    @department.get_settings(Date.today)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def employee
    @employees = @department.employees.order(id: :desc)
    @view = 'employee_list'
    respond_to do |format|
      format.html { render :show }
      format.js { render :show }
      format.xls do
        render xls: 'Employees', layout: 'excel', template: 'employees/employee_list_xls_doc.html.erb', encoding: 'utf-8'
      end
      format.pdf do
        render pdf: 'Employees', layout: 'pdf', template: 'employees/employee_list_pdf.html.erb', encoding: 'utf-8'
      end
      format.docx do
        render docx: 'Employees', layout: 'document', template: 'employees/employee_list_xls_doc.html.erb', encoding: 'utf-8'
      end
    end
  end

  def leave
    year = params[:date].present? ? params[:date][:year].to_i : Date.today.year
    @leave_categories = @department.leave_categories
    @leave_category_years = Leave::CategoryYear.hashed_items(@department, @leave_categories, year)
    @view = 'settings/leave'
    render :show
  end

  def budget
    year = params[:date].present? ? params[:date][:year].to_i : Date.today.year
    @view = 'settings/budget'
    @categories = @department.expenses_categories.where(expense_category_id: nil)
    @setting = @department.setting
    render :show
  end

  def general
    @setting = @department.setting
    @changed_settings = @department.changed_settings
    @view = 'settings/general'
    render :show
  end

  def attendance
    @events = @department.events
    @view = 'settings/attendance'
    render :show
  end

  def designation
    @designations = @department.designations
    @view = 'designation_list'
    respond_to do |format|
      format.html { render :show }
      format.js { render :show }
      format.xls do
        render xls: 'Designations', layout: 'excel', template: 'departments/designations_xls_docx.html.erb', encoding: 'utf-8'
      end
      format.pdf do
        render pdf: 'Designations', layout: 'pdf', template: 'departments/designations_pdf.html.erb', encoding: 'utf-8'
      end
      format.docx do
        render docx: 'Designations', layout: 'document', template: 'departments/designations_xls_docx.html.erb', encoding: 'utf-8'
      end
    end
  end

  def update
    respond_to do |format|
      if @department.update(department_params)
        format.html { redirect_to @department, notice: "Department was successfully created" }
        format.json { render :show, status: :ok, location: @department }
        format.js
      else
        format.html { render :new }
        format.json { render json: @department.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def destroy
    respond_to do |format|
      if @department == current_employee.department
        format.html { redirect_to profile_companies_path, notice: 'You are in the department So you have to switch yourself to another department' }
        format.json { head :no_content }
        format.js
      else
        @department.destroy!
        format.html { redirect_to profile_companies_path, notice: 'Successfully deleted' }
        format.json { head :no_content }
        format.js
      end
    end
  end

  def switch
    @department = Department.friendly.find(params[:id])
    session[:department_id] = @department.id if @department.present?
    if Rails.application.routes.recognize_path(request.referrer)[:controller] == 'departments' && (Department::SWITCH_ACTIONS.values.include? Rails.application.routes.recognize_path(request.referrer)[:action])
      redirect_to @department.action_path(Rails.application.routes.recognize_path(request.referrer)[:action])
    else
      redirect_to request.referer
    end
  end

  def all_settings
    @setting = @department.setting
    @designations = @department.designations
    @leave_categories = @department.leave_categories
    @categories = @department.payroll_categories
  end

  private

  def set_department
    begin
      @department = Department.where(company_id: current_company.id).friendly.find(params[:id]) #.departments.friendly.find(params[:id])
    rescue
      @department = current_department
    end
  end

  def department_params
    params.require(:department).permit!
  end

end
