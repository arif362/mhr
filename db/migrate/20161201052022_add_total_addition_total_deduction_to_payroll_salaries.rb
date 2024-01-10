class AddTotalAdditionTotalDeductionToPayrollSalaries < ActiveRecord::Migration
  def change
    add_column :payroll_salaries, :total_addition, :float
    add_column :payroll_salaries, :total_deduction, :float
  end
end
