class RemoveColumnDaysFromLeaveCategories < ActiveRecord::Migration
  def change
    remove_column :leave_categories, :days
  end
end
