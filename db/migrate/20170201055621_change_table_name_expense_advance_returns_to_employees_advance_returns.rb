class ChangeTableNameExpenseAdvanceReturnsToEmployeesAdvanceReturns < ActiveRecord::Migration
  def change
    rename_table :expense_advance_returns, :employees_advance_returns
  end
end
