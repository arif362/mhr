class AddIsPercentageToPayrollCategories < ActiveRecord::Migration
  def change
    add_column :payroll_categories, :is_percentage, :boolean, default: false
  end
end
