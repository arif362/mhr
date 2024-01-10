class AddColumnIsConfirmedToPayrollSalaries < ActiveRecord::Migration
  def change
    add_column :payroll_salaries, :is_confirmed, :boolean, default: true
  end
end
