class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.string :name
      t.decimal :cost
      t.text :description
      t.string :module

      t.timestamps null: false
    end
  end
end
