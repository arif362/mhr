class CreateBudgets < ActiveRecord::Migration
  def change
    create_table :expense_budgets do |t|
      t.integer :category_id
      t.integer :department_id
      t.integer :company_id
      t.integer :year
      t.float :amount

      t.timestamps null: false
    end
  end
end
