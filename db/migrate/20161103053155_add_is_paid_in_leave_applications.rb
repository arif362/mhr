class AddIsPaidInLeaveApplications < ActiveRecord::Migration
  def change
    add_column :leave_applications, :is_paid, :boolean, default: false
  end
end
