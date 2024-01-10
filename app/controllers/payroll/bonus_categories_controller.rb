module Payroll
  class BonusCategoriesController < BaseController
    before_filter :current_ability
    before_action :set_bonus_category, only: [:show, :edit, :update, :destroy]

    def index
      @bonus_categories = current_department.bonus_categories
    end

    def show
      respond_to do |format|
        format.js
      end
    end

    def new
      @bonus_category = Payroll::BonusCategory.new
      respond_to do |format|
        format.js
      end
    end

    def create
      @bonus_category = current_department.bonus_categories.build(bonus_category_params)
      unless params[:payroll_bonus_category][:is_amount].present?
        @bonus_category.is_amount = false
      end
      if params[:employee_id].present?
        @employee = employee(params[:employee_id])
        if @bonus_category.save && @employee.basic_salary.present?
          amount = @bonus_category.is_amount ? @bonus_category.amount : @employee.basic_salary * (@bonus_category.amount / 100)
          @bonus_payment = Payroll::BonusPayment.new(reason: @bonus_category.name, amount: amount, employee_id: @employee.id, department_id: current_department.id, message: @bonus_category.message )
        end
      else
        @bonus_category.save
      end
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
      @bonus_category.update(bonus_category_params)
      unless params[:payroll_bonus_category][:is_amount].present?
        @bonus_category.update(is_amount: false)
      end
      respond_to do |format|
        format.js
      end
    end

    def destroy
      @bonus_category.destroy
      respond_to do |format|
        format.js
      end
    end

    private

    def set_bonus_category
      @bonus_category = current_department.bonus_categories.find_by_id(params[:id])
    end

    def bonus_category_params
      params.require(:payroll_bonus_category).permit!
    end

    def employee(employee_id)
      current_department.employees.find_by_id(employee_id)
    end

  end
end

