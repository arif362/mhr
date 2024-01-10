class AddColumnKinRelationshipToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :kin_relationship, :string
    add_column :employees, :marital_status, :string
    add_column :employees, :nationality, :string
  end
end
