class ChangeStatusDefaultValues < ActiveRecord::Migration
  def change
    change_column :leave_applications, :status, :string, default: AppSettings::STATUS[:pending]
    change_column :expense_expenses, :status, :string, default: AppSettings::STATUS[:pending]
  end
end
