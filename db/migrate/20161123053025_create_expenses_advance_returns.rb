class CreateExpensesAdvanceReturns < ActiveRecord::Migration
  def change
    create_table :expense_advance_returns do |t|
      t.date :date
      t.float :amount
      t.references :employee
      t.references :department
      t.integer :advance_id
      t.integer :salary_id
      t.string :return_from
      t.timestamps null: false
    end
  end
end
