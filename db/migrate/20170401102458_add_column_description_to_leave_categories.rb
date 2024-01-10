class AddColumnDescriptionToLeaveCategories < ActiveRecord::Migration
  def change
    add_column :leave_categories, :description, :text
    add_column :leave_categories, :is_active, :boolean, default: true
  end
end
