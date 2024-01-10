class ChangeBoodGroupToEmployees < ActiveRecord::Migration
  def change
    rename_column :employees, :bood_group, :blood_group
  end
end
