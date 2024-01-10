class CreateProvidentFundAccounts < ActiveRecord::Migration
  def change
    create_table :provident_fund_accounts do |t|
      t.string :number
      t.integer :rule_id
      t.integer :employee_id
      t.date :effective_date

      t.timestamps null: false
    end
  end
end
