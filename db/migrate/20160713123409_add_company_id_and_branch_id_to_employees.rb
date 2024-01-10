class AddCompanyIdAndBranchIdToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :company_id, :integer
    add_column :employees, :branch_id, :integer
  end
end
