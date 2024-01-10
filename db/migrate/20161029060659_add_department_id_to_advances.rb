class AddDepartmentIdToAdvances < ActiveRecord::Migration
  def change
    add_column :expenses_advances, :department_id, :integer
  end
end
