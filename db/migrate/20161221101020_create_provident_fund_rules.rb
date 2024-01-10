class CreateProvidentFundRules < ActiveRecord::Migration
  def change
    create_table :provident_fund_rules do |t|
      t.float :company_contribution
      t.string :employee_contribution
      t.integer :department_id

      t.timestamps null: false
    end
  end
end
