class AddAddressToDepartments < ActiveRecord::Migration
  def change
    add_column :departments, :address, :text
  end
end
