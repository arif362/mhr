class AddDepartmentIdToAttendances < ActiveRecord::Migration
  def change
    add_column :attendances, :department_id, :integer
  end
end
