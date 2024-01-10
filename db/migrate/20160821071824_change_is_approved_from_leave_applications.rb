class ChangeIsApprovedFromLeaveApplications < ActiveRecord::Migration
  def change
    change_column :leave_applications, :is_approved, :string, default: AppSettings::STATUS[:pending]
  end
end
