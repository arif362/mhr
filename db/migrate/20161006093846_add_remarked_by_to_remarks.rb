class AddRemarkedByToRemarks < ActiveRecord::Migration
  def change
    add_column :remarks, :remarked_by_id, :integer
  end
end
