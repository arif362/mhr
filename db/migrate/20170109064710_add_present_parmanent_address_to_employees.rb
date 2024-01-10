class AddPresentParmanentAddressToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :present_address, :string
    add_column :employees, :permanent_address, :string
    remove_column :employees, :city
    remove_column :employees, :country
    remove_column :employees, :state
    remove_column :employees, :zip_code
  end
end
