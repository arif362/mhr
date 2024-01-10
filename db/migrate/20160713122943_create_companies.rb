class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.text :description
      t.string :image
      t.integer :company_type_id
      t.integer :company_id
    end
  end
end
