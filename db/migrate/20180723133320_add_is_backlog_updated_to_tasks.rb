class AddIsBacklogUpdatedToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :is_backlog_updated, :boolean, default:false
  end
end
