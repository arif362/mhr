class CreateExpenseCategories < ActiveRecord::Migration
  def change
    create_table :expense_categories do |t|
      t.string :name
      t.string :description
      t.integer :department_id
      t.timestamps null: false
    end
  end
end
