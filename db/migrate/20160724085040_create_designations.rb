class CreateDesignations < ActiveRecord::Migration
  def change
    create_table :designations do |t|
      t.string :name
      t.text :description
      t.boolean :is_active
      t.integer :department

      t.timestamps null: false
    end
  end
end
