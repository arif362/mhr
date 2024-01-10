class AddCurrencyFieldToInvoice < ActiveRecord::Migration
  def change
    add_column :billing_invoices, :currency, :string, default: 'USD'
  end
end
