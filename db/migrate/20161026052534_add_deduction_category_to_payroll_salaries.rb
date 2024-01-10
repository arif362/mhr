class AddDeductionCategoryToPayrollSalaries < ActiveRecord::Migration
  def change
    add_column :payroll_salaries, :deduction_category, :string
  end
end
