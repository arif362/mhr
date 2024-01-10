class ChangeRoleFromEmployees < ActiveRecord::Migration
  EMPLOYEE_ROLE = ['staff','admin']
  def change
    change_column :employees, :role, :string,:default=> EMPLOYEE_ROLE[0]
  end
end
