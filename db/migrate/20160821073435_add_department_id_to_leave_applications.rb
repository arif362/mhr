class AddDepartmentIdToLeaveApplications < ActiveRecord::Migration
  def change
    add_column :leave_applications, :department_id, :integer
  end
end
