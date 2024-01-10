class ChangeDeductionCategoryDataType < ActiveRecord::Migration
  def change
    change_column :payroll_salaries, :deduction_category, :text
  end
end
