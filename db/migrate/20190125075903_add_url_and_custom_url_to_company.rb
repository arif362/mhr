class AddUrlAndCustomUrlToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :url, :string
    add_column :companies, :custom_url, :string
  end
end
