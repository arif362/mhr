class CreateBillingClients < ActiveRecord::Migration
  def change
    create_table :billing_clients do |t|
      t.string :organization_name
      t.integer :department_id
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :home_phone
      t.string :mobile_number
      t.string :send_invoice_by
      t.string :country
      t.string :address_street1
      t.string :address_street2
      t.string :city
      t.string :province_state
      t.string :postal_zip_code
      t.string :industry
      t.string :company_size
      t.string :business_phone
      t.string :fax
      t.text :internal_notes
      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
