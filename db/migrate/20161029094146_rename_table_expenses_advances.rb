class RenameTableExpensesAdvances < ActiveRecord::Migration
  def change
    rename_table :expenses_advances, :expense_advances
  end
end
