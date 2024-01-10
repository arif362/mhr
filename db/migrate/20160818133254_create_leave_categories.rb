class CreateLeaveCategories < ActiveRecord::Migration
  def change
    create_table :leave_categories do |t|
      t.string :name
      t.integer :days
      t.integer :department_id

      t.timestamps null: false
    end
  end
end
