class RemoveColumnFromEmployees < ActiveRecord::Migration
  def change
    remove_column :employees, :next_path
  end
end
