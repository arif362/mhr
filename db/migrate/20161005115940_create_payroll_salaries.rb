class CreatePayrollSalaries < ActiveRecord::Migration
  def change
    create_table :payroll_salaries do |t|
      t.integer :employee_id
      t.integer :department_id
      t.string :payment_method
      t.text :addition_category
      t.text :addition_category
      t.decimal :overtime
      t.decimal :bonus
      t.decimal :deduction
      t.decimal :total

      t.timestamps null: false
    end
  end
end
