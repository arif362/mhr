class CreateCompanyFeatures < ActiveRecord::Migration
  def change
    create_table :company_features do |t|
      t.integer :feature_id
      t.integer :company_id

      t.timestamps null: false
    end
  end
end
