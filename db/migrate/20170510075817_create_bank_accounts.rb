class CreateBankAccounts < ActiveRecord::Migration
  def change
    create_table :bank_accounts do |t|
      t.references :department, index: true, foreign_key: true
      t.string :name
      t.string :number
      t.string :bank_name
      t.string :bank_branch
      t.float :balance

      t.timestamps null: false
    end
  end
end
