class AddColumnEmailAndMobileToDepartments < ActiveRecord::Migration
  def change
    add_column :departments, :email, :string
    add_column :departments, :mobile, :string
  end
end
