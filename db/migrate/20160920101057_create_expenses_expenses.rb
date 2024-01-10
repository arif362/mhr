class CreateExpensesExpenses < ActiveRecord::Migration
  def change
    create_table :expense_expenses do |t|
      t.text :description
      t.integer :expense_category_id
      t.integer :expense_sub_category_id
      t.float :amount
      t.integer :department_id
      t.date :date
      t.boolean :is_approved, default: false
      t.integer :created_by_id
      t.integer :approved_by_id
      t.string :received_by
      t.string :attachment
      t.string :payment_method
      t.string :status, default: AppSettings::STATUS[:pending]
      t.timestamps null: false
    end
  end
end
