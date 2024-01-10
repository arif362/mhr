class CreateExpensesAdvances < ActiveRecord::Migration
  def change
    create_table :expenses_advances do |t|
      t.integer :employee_id
      t.decimal :amount
      t.boolean :is_paid, default: false
      t.text :purpose

      t.timestamps null: false
    end
  end
end
