class ChangeIsAddToPayrollCategories < ActiveRecord::Migration
  def change
    change_column :payroll_categories, :is_add, :boolean, default: true
  end
end
