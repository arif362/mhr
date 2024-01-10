class CompaniesController < ApplicationController
  before_action :complete_profile, except: [:new, :create]
  before_filter :current_ability
  before_action :set_company, only: [:profile, :update, :edit, :employee, :departments]

  def profile
    @departments = @company.departments.includes(:employees)
    respond_to do |format|
      format.js
      format.html
    end
  end

  def employee
    @departments = @company.departments.includes(:employees)
    @view = 'companies/templates/company_employees'
    respond_to do |format|
      format.html { render :profile }
      format.js { render :profile }
      format.xls do
        render xls: 'Employees', layout: 'excel', template: 'companies/employees_xls_docx.html.erb', encoding: 'utf-8'
      end
      format.pdf do
        render pdf: 'Employees', layout: 'pdf', template: 'companies/employees_pdf.html.erb', encoding: 'utf-8'
      end
      format.docx do
        render docx: 'Employees', layout: 'document', template: 'companies/employees_xls_docx.html.erb', encoding: 'utf-8'
      end
    end
  end

  def departments
    @departments = @company.departments.includes(:employees)
    @view = 'companies/templates/company_departments'
    respond_to do |format|
      format.html { render :profile }
      format.js { render :profile }
      format.xls do
        render xls: 'Departments', layout: 'excel', template: 'companies/departments_xls_docx.html.erb', encoding: 'utf-8'
      end
      format.pdf do
        render pdf: 'Departments', layout: 'pdf', template: 'companies/departments_pdf.html.erb', encoding: 'utf-8'
      end
      format.docx do
        render docx: 'Departments', layout: 'document', template: 'companies/departments_xls_docx.html.erb', encoding: 'utf-8'
      end
    end
  end

  def new
    if current_employee.super_admin?
      @company = Company.new(employee_id: current_employee.id)
    else
      flash[:danger] = "Unauthorized Access"
      redirect_to :back
    end
  end

  def create
    Employee.prepare_company(current_employee, company_params)
    session[:department_id] = current_employee.department.id
    redirect_to current_company.next_path
  end

  def edit
    respond_to do |format|
      format.js
    end
  end


  def update
    @company = Company.find_by_id(params[:id])
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to profile_companies_path, notice: 'Company was successfully updated.' }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { redirect_to profile_companies_path, notice: "Company wasn't updated" }
        format.json { render @company.errors, status: :unprocessable_entity }
      end

    end
  end

  private

  def set_company
    @company = current_department.company
  end

  def company_params
    params.require(:company).permit!
  end
end
