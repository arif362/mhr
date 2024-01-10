class AddReligionToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :religion, :string
  end
end
