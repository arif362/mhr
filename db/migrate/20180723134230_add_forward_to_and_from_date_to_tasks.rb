class AddForwardToAndFromDateToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :forward_to_date, :date
    add_column :tasks, :forward_from_date, :date
  end
end
