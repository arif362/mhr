class AddBasicSalaryToPayrollSalaries < ActiveRecord::Migration
  def change
    add_column :payroll_salaries, :basic_salary, :float
  end
end
