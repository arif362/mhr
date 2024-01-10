class SplitCompanyAddressAndRemoveAbout < ActiveRecord::Migration
  def change
    add_column :companies, :city, :string
    add_column :companies, :state, :string
    add_column :companies, :zip_code, :string
    add_column :companies, :country, :string
    remove_column :companies, :description
  end
end
