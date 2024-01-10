class AddColumnCountryToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :country, :string
  end
end
