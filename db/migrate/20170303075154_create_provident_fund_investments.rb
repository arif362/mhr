class CreateProvidentFundInvestments < ActiveRecord::Migration
  def change
    create_table :provident_fund_investments do |t|
      t.string :title
      t.string :pf_type
      t.string :amount
      t.date :maturity_date
      t.float :no_year
      t.date :date
      t.float :interest_rate
      t.integer :no_day
      t.integer :department_id
      t.boolean :active, default: true
      t.timestamps null: false
    end
  end
end
