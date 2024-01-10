class AddFieldsToExpensesAdvances < ActiveRecord::Migration
  def change
    add_column :expense_advances, :is_completed, :boolean, default: false
    add_column :expense_advances, :installment, :float
    add_column :expense_advances, :return_policy, :string
    add_column :expense_advances, :date, :date
  end
end
