class AddMonthAndYearToPayrollSalaries < ActiveRecord::Migration
  def change
    add_column :payroll_salaries, :month, :integer
    add_column :payroll_salaries, :year, :integer
  end
end
