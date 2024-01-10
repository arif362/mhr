module Payroll
  class CategoriesController < BaseController
    before_filter :current_ability
    before_action :set_category, only: [:show, :edit, :update, :destroy]

    def index
      @categories = current_department.payroll_categories
      respond_to do |format|
        format.html
        format.xls do
          render xls: 'Payroll Categories', layout: 'excel', template: 'payroll/categories/categories_xls_docx.html.erb', encoding: 'utf-8'
        end
        format.pdf do
          render pdf: 'Payroll Categories', layout: 'pdf', template: 'payroll/categories/categories_pdf.html.erb', encoding: 'utf-8'
        end
        format.docx do
          render docx: 'Payroll Categories', layout: 'document', template: 'payroll/categories/categories_xls_docx.html.erb', encoding: 'utf-8'
        end
      end
    end

    def show
      respond_to do |format|
        format.js
      end
    end

    def new
      @category = params[:department].present? ? Payroll::Category.new(department_id: params[:department]) : Payroll::Category.new
      respond_to do |format|
        format.js
      end
    end

    def create
      department = params[:payroll_category][:department_id].present? ? Department.find(params[:payroll_category][:department_id]) : current_department
      @category = department.payroll_categories.build(category_params)
      unless params[:payroll_category][:is_add].present?
        @category.is_add = false
      end
      unless params[:payroll_category][:is_percentage].present?
        @category.is_percentage = false
      end
      respond_to do |format|
        @category.save
        format.js
      end
    end

    def edit
      respond_to do |format|
        format.js
      end
    end

    def update
      is_add = params[:payroll_category][:is_add].present? ? params[:payroll_category][:is_add] : false
      is_percentage = params[:payroll_category][:is_percentage].present? ? params[:payroll_category][:is_percentage] : false
      @category.update(name: params[:payroll_category][:name], description: params[:payroll_category][:description], is_add: is_add, is_percentage: is_percentage)
      respond_to do |format|
        format.js
      end
    end

    def destroy
      if @category.destroy
        @number_of_categories = current_department.payroll_categories.count
      end
      respond_to do |format|
        format.js
      end
    end

    def setup
      if params[:payroll_employee_category].present?
        payroll_employee_categories = params[:payroll_employee_category]
        payroll_employee_categories.each_with_index  do |category, index|
          employee_category = Payroll::EmployeeCategory.new(employee_id: category[1][:employee_id].to_i , category_id:  category[1][:category_id].to_i, percentage: category[1][:percentage].present? ? category[1][:percentage].to_i: '', amount: category[1][:amount].present? ? category[1][:amount].to_i: '' )
          employee_category.save
        end
      elsif params[:employee].present?
        @employee = Employee.find(params[:id]).update(employee_params)
      end
        redirect_to payroll_categories_path
    end

    private
    def set_category
      @category = current_department.payroll_categories.find(params[:id])
    end

    def set_employee(employee)
      current_department.employees.find(employee)
    end

    def category_params
      params.require(:payroll_category).permit!
    end

    def employee_params
      params.require(:employee).permit!
    end

  end
end