class ChangeDescriptionToMessageOfPayrollBonusCategories < ActiveRecord::Migration
  def change
    remove_column :payroll_bonus_categories, :description
    add_column :payroll_bonus_categories, :message, :text
  end
end
