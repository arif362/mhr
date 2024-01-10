class AddBasicInfoToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :first_name, :string
    add_column :employees, :last_name, :string
    add_column :employees, :middle_name, :string
    add_column :employees, :bio, :text
    add_column :employees, :country, :string
    add_column :employees, :state, :string
    add_column :employees, :city, :string
    add_column :employees, :zip_code, :integer
    add_column :employees, :location, :string
    add_column :employees, :dob, :date
    add_column :employees, :address, :text
  end
end
