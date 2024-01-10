module Expenses
  class CategoriesController < BaseController
    before_filter :current_ability
    before_action :set_expense_category, only: [:edit, :update, :destroy]

    def index
      @expense_categories = Expenses::Category.all_expense_categories(current_department).includes(:expense_sub_categories)
    end

    def new
      @expense_category = Expenses::Category.new
      respond_to do |format|
        format.js
      end
    end

    def show
      @expense_category = Expenses::Category.find_by_id(params[:id])

    end

    def create
      @expense_category = current_department.expenses_categories.build(expense_category_params)
      respond_to do |format|
        if @expense_category.save
          format.html {redirect_to expenses_categories_path, notice: "Expense Category has been created successfully"}
          format.js
          format.json { render json: @expense_category }
        else
          format.html {render :new, notice: "Expense Category couldn't be created"}
          format.js
          format.json { render json: @expense_category.errors, status: :unprocessable_entity }
        end
      end
    end

    def edit
      respond_to do |format|
        format.js
      end
    end

    def update
      respond_to do |format|
        if @expense_category.update(expense_category_params)
          format.html { redirect_to @expense_category, notice: 'Expense Category has been updated successfully'}
          format.json { render @expense_category, status: :ok}
          format.js
        else
          format.html { render :new, notice: "Expense Category couldn't be updated"}
          format.json { render @expense_category.errors, status: :unprocessable_entity}
          format.js
        end
      end
    end

    def destroy
      @category_id = @expense_category.id
      @sub_category_id = nil
      if @expense_category.expense_category_id.present?
        @category_id = @expense_category.expense_category_id
        @sub_category_id = @expense_category.id
      end
      @expense_category.destroy
      respond_to do |format|
        format.js
      end
    end

    def sub_categories
      @sub_categories = Expenses::Category.sub_categories_from_category(params[:id])
      respond_to do |format|
        format.js
      end
    end

    private
    def set_expense_category
      @expense_category = Expenses::Category.find_by_id(params[:id])
    end

    def expense_category_params
      params.require(:expenses_category).permit!
    end
  end
end
