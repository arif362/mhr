class ChangeBioFromEmployees < ActiveRecord::Migration
  def change
    rename_column :employees, :bio, :note
  end
end
