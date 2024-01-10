class ChangeBranchIdToDepartmentIdFromEmployees < ActiveRecord::Migration
  def change
    rename_column :employees, :branch_id, :department_id
  end
end
