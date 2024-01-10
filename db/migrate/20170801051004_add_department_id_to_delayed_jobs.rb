class AddDepartmentIdToDelayedJobs < ActiveRecord::Migration
  def change
    add_column :delayed_jobs, :source_id, :integer, index: true
  end
end
