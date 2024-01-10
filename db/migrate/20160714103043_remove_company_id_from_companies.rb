class RemoveCompanyIdFromCompanies < ActiveRecord::Migration
  def change
    remove_column :companies, :company_id, :integer
  end
end
