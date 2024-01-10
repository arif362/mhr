class CreatePayrollIncrements < ActiveRecord::Migration
  def change
    create_table :payroll_increments do |t|
      t.integer :employee_id
      t.integer :department_id
      t.decimal :present_basic
      t.decimal :previous_basic
      t.decimal :incrmnt_amount
      t.boolean :is_active
      t.date :active_date

      t.timestamps null: false
    end
  end
end
