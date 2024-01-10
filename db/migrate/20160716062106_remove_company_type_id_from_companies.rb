class RemoveCompanyTypeIdFromCompanies < ActiveRecord::Migration
  def change
    remove_column :companies, :company_type_id, :integer
  end
end
