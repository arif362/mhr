module Payroll
  class EmployeeCategoriesController < ApplicationController
    before_filter :current_ability
    before_action :set_employee_categories, only: [:edit, :update, :destroy]
    def new
      @employee = employee(params[:employee_id])
      @employee_category = @employee.payroll_employee_categories.new(category_id: params[:category_id])
      respond_to do |format|
        format.js
      end
    end

    def create
      @employee_category = Payroll::EmployeeCategory.create(employee_category_params)
      @employee = @employee_category.employee
      respond_to do |format|
        format.js
      end
    end

    def edit
      respond_to do |format|
        format.js
      end
    end
    
    def update
      if @employee_category.update(employee_category_params)
        respond_to do |format|
          format.js
        end
      end
    end

    def destroy
      @employee = employee(@employee_category.employee_id)
      @category = current_department.payroll_categories.find(@employee_category.category_id)
      if @employee_category.delete
        respond_to do |format|
          format.js
        end
      end
    end

    private

    def employee(employee)
      current_department.employees.find(employee)
    end

    def set_employee_categories
      @employee_category = Payroll::EmployeeCategory.find(params[:id])
      @employee = @employee_category.employee
    end

    def employee_category_params
      params.require(:payroll_employee_category).permit!
    end
  end
end