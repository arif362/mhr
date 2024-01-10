class CreateLeaveCategoryYears < ActiveRecord::Migration
  def change
    create_table :leave_category_years do |t|
      t.integer :department_id
      t.integer :leave_category_id
      t.integer :year
      t.integer :days
      t.timestamps null: false
    end
  end
end
