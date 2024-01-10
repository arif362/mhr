class ChangeTableNameExpensesAdvancesToEmployeesAdvances < ActiveRecord::Migration
  def change
    rename_table :expense_advances, :employees_advances
  end
end
