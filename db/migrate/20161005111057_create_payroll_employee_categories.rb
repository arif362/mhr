class CreatePayrollEmployeeCategories < ActiveRecord::Migration
  def change
    create_table :payroll_employee_categories do |t|
      t.integer :employee_id
      t.integer :category_id
      t.string :percentage
      t.decimal :amount

      t.timestamps null: false
    end
  end
end
