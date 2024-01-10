class ChangeDepartmentToDesignations < ActiveRecord::Migration
  def change
    rename_column :designations, :department, :department_id
  end
end
