class AddNextPathToEmployee < ActiveRecord::Migration
  def change
    add_column :employees, :next_path, :string
  end
end
