class CreatePayrollBonusPayments < ActiveRecord::Migration
  def change
    create_table :payroll_bonus_payments do |t|
        t.string :reason
        t.text :message
        t.float :amount
        t.references :employee
        t.references :department
        t.timestamps null: false
    end
  end
end
