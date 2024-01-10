class AddTypeToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :employee_type, :string
  end
end
