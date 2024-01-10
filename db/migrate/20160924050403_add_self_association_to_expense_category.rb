class AddSelfAssociationToExpenseCategory < ActiveRecord::Migration
  def change
    add_column :expense_categories, :expense_category_id, :integer, default: nil
    drop_table :expense_sub_categories
  end
end
