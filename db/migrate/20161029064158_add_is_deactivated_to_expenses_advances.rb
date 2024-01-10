class AddIsDeactivatedToExpensesAdvances < ActiveRecord::Migration
  def change
    add_column :expenses_advances, :is_deactivated, :boolean, default: false
  end
end
