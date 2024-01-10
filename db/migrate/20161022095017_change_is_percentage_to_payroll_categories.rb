class ChangeIsPercentageToPayrollCategories < ActiveRecord::Migration
  def change
    change_column :payroll_categories, :is_percentage, :boolean, default: true
  end
end
