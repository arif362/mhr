class AddDeactivateDateToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :deactivate_date, :date
  end
end
