class CreateExpenseSubCategories < ActiveRecord::Migration
  def change
    create_table :expense_sub_categories do |t|
      t.string :name
      t.string :description
      t.integer :expense_category_id
      t.timestamps null: false
    end
  end
end
