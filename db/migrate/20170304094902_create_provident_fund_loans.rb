class CreateProvidentFundLoans < ActiveRecord::Migration
  def change
    create_table :provident_fund_loans do |t|
      t.integer :pf_account_id
      t.integer :department_id
      t.float :amount
      t.text :description
      t.string :return_policy
      t.integer :installment
      t.date :return_date
      t.date :date
      t.boolean :is_closed, default: false
      t.timestamps null: false
    end
  end
end
