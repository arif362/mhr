class AddContactNoContactEamilAddressToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :mobile, :string
    add_column :companies, :contact_email, :string
    add_column :companies, :address, :string
  end
end
