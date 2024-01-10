class AddIsActiveToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :is_active, :boolean, default: true
    add_column :employees, :deactivated_by, :integer
  end
end
