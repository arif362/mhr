class AddTotalDaysToLeaveApplications < ActiveRecord::Migration
  def change
    add_column :leave_applications, :total_days, :integer
  end
end
