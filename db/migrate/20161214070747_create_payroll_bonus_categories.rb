class CreatePayrollBonusCategories < ActiveRecord::Migration
  def change
    create_table :payroll_bonus_categories do |t|
      t.string :name
      t.text :description
      t.boolean :is_amount, default: true
      t.float :amount
      t.timestamps null: false
    end
  end
end
