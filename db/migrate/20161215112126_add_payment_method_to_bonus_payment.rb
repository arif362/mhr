class AddPaymentMethodToBonusPayment < ActiveRecord::Migration
  def change
    add_column :payroll_bonus_payments, :payment_method, :string
  end
end
