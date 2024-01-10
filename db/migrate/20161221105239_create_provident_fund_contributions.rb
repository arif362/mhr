class CreateProvidentFundContributions < ActiveRecord::Migration
  def change
    create_table :provident_fund_contributions do |t|
      t.integer :provident_fund_account_id
      t.float :basis_salary
      t.float :employee_contribution
      t.float :company_contribution
      t.integer :month
      t.integer :year
      t.boolean :is_confirmed, default: false

      t.timestamps null: false
    end
  end
end
