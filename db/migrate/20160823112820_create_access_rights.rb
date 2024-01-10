class CreateAccessRights < ActiveRecord::Migration
  def change
    create_table :access_rights do |t|
      t.references :employee, index: true
      t.text :permissions
      t.text :custom_permissions

      t.timestamps null: false
    end
  end
end
