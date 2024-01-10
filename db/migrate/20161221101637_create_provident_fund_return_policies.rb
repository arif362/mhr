class CreateProvidentFundReturnPolicies < ActiveRecord::Migration
  def change
    create_table :provident_fund_return_policies do |t|
      t.float :year
      t.float :company_percentage
      t.integer :rule_id

      t.timestamps null: false
    end
  end
end
