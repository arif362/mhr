class AddEmployeeIdToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :employee_id, :integer
  end
end
