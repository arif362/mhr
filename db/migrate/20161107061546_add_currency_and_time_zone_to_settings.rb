class AddCurrencyAndTimeZoneToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :time_zone, :string, default: 'UTC'
    add_column :settings, :currency, :string
  end
end
