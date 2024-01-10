class SplitDepartmentAddressField < ActiveRecord::Migration
  def change
    add_column :departments, :city, :string
    add_column :departments, :state, :string
    add_column :departments, :zip_code, :string
    add_column :departments, :country, :string
  end
end
