class CreatePayrollCategories < ActiveRecord::Migration
  def change
    create_table :payroll_categories do |t|
      t.string :name
      t.text :description
      t.integer :department_id
      t.boolean :is_add

      t.timestamps null: false
    end
  end
end
