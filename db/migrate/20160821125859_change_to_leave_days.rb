class ChangeToLeaveDays < ActiveRecord::Migration
  def change
    rename_column :leave_days, :off_date, :day
    add_column :leave_days, :is_approved, :boolean, default: false
  end
end
