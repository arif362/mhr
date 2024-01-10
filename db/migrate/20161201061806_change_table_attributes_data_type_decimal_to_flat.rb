class ChangeTableAttributesDataTypeDecimalToFlat < ActiveRecord::Migration
  def change
    change_column :settings, :working_hours, :float
    change_column :payroll_salaries, :total, :float
    change_column :payroll_salaries, :bonus, :float
    remove_column :payroll_salaries, :overtime
    remove_column :payroll_salaries, :deduction
    change_column :attendance_attendances, :duration, :float
    change_column :attendance_day_offs, :hours, :float
    change_column :employees, :basic_salary, :float
    change_column :expense_advances, :amount, :float
    change_column :features, :cost, :float
    change_column :payroll_employee_categories, :amount, :float

    remove_column :payroll_employee_categories, :percentage
    add_column :payroll_employee_categories, :percentage, :float

    change_column :payroll_increments, :present_basic, :float
    change_column :payroll_increments, :previous_basic, :float
    remove_column :payroll_increments, :incrmnt_amount
    add_column :payroll_increments, :increment_amount, :float
  end
end
