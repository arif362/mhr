class AddDepartmentIdToPayrollBonusCategories < ActiveRecord::Migration
  def change
    add_reference :payroll_bonus_categories, :department, index: true
  end
end
