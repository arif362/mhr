class AddVoucherNumberFieldToExpenseExpenses < ActiveRecord::Migration
  def change
    add_column :expense_expenses, :voucher_number, :text
  end
end
