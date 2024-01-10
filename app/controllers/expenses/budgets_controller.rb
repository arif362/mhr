module Expenses
  class BudgetsController < BaseController
    before_filter :current_ability

    def new
      @department = @cur_department
      @expense_categories = Expenses::Category.all_expense_categories(current_department).includes(:expense_sub_categories)
      unless @expense_categories.present?
        redirect_to department_path(@cur_department), notice: "Create expense category from expense module to add budget."
      end
    end

    def create
      params[:amount].each do |key, value|
        if value.present?
          val = value
        else
          val = 0
        end
        @cur_department.expenses_budgets.create(company_id: @cur_department.company_id, amount: val, category_id: key, year: params[:date][:year])
      end
      redirect_to budget_department_path(current_department), notice: "Expense Budget has been created"
    end


    def edit
      @budget = @cur_department.expenses_budgets.find_by_id(params[:id])
      respond_to do |format|
        format.js
      end
    end

    def update
      @budget = @cur_department.expenses_budgets.find_by_id(params[:id])
      respond_to do |format|
        if @budget.update_attributes(amount: params[:expenses_budget][:amount])
          format.html { redirect_to budget_department_path(current_department), notice: "Expense Budget has been updated" }
          format.js
          format.json
        else
          format.html { redirect_to budget_department_path(current_department), notice: "Expense Budget couldn't be updated." }
          format.js
          format.json
        end
      end
    end


    def update_budget
      params[:amount].each do |key, value|
        if value.present?
          val = value
        else
          val = 0
        end
        bud = @cur_department.expenses_budgets.where(company_id: @cur_department.company_id, category_id: key, year: params[:date][:year]).first_or_initialize
        bud.amount = val
        bud.save
      end
      redirect_to budget_department_path(current_department), notice: "Expense Budget has been updated"
    end

    def get_budget
      @budgets = @cur_department.expenses_budgets.where(year: params[:year])
    end

  end

  private

  def budget_params
    params.require(:expenses_budget).permit!
  end
end

