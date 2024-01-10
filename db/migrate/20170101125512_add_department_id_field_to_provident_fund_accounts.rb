class AddDepartmentIdFieldToProvidentFundAccounts < ActiveRecord::Migration
  def change
    add_column :provident_fund_accounts, :department_id, :integer
  end
end
