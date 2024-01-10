class AddEmployeeInfoToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :bood_group, :string
    add_column :employees, :joining_date, :date
    add_column :employees, :designation_id, :integer
    add_column :employees, :salary, :decimal
    add_column :employees, :mobile, :string
    add_column :employees, :nid, :string
    add_column :employees, :kin_name, :string
    add_column :employees, :kin_contact, :string
    remove_column :employees, :middle_name
  end
end
