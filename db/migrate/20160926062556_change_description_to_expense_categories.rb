class ChangeDescriptionToExpenseCategories < ActiveRecord::Migration
  def change
    change_column :expense_categories, :description, :text
  end
end
