class ChangeIsApprovedToLeaveApplications < ActiveRecord::Migration
  def change
    remove_column :leave_applications, :is_approved
    add_column :leave_applications, :is_approved, :boolean, default: false
    add_column :leave_applications, :status, :string, default: AppSettings::STATUS[:pending]
  end
end
