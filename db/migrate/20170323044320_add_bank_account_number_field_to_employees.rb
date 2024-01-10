class AddBankAccountNumberFieldToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :bank_account_number, :string
    add_column :employees, :bank_details, :text
  end
end
