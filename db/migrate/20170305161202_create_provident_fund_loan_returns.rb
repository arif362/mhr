class CreateProvidentFundLoanReturns < ActiveRecord::Migration
  def change
    create_table :provident_fund_loan_returns do |t|
      t.date          :date
      t.float         :amount
      t.integer       :department_id
      t.integer       :loan_id
      t.timestamps null: false
    end
  end
end
