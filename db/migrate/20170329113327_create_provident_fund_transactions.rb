class CreateProvidentFundTransactions < ActiveRecord::Migration
  def change
    create_table :provident_fund_transactions do |t|
      t.string :transable_type
      t.integer :transable_id
      t.float :debit
      t.float :credit
      t.float :pf_account_id
      t.integer :department_id

      t.timestamps null: false
    end
  end
end
