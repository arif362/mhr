class AddIncrementedByToIncrements < ActiveRecord::Migration
  def change
    add_column :payroll_increments, :incremented_by, :string
  end
end
