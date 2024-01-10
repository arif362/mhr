class AddColumnFromCombinedToPayrollSalaries < ActiveRecord::Migration
  def change
    add_column :payroll_salaries, :from_combined, :boolean, default: false
  end
end
