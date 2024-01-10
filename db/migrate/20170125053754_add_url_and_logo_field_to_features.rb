class AddUrlAndLogoFieldToFeatures < ActiveRecord::Migration
  def change
    add_column :features, :url, :string
    add_column :features, :logo, :string
  end
end
