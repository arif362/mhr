class AddColumnDateToPayrollBonusPayments < ActiveRecord::Migration
  def change
    add_column :payroll_bonus_payments, :date, :date
  end
end
