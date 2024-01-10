class CreateClientContacts < ActiveRecord::Migration
  def change
    create_table :billing_client_contacts do |t|
      t.integer :client_id
      t.string  :first_name
      t.string  :last_name
      t.string  :email
      t.string  :home_phone
      t.string  :mobile_number
      t.datetime :deleted_at
      t.datetime :created_at,     null: false
      t.datetime :updated_at,     null: false
    end
  end
end
