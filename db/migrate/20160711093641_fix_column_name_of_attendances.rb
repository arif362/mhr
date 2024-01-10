class FixColumnNameOfAttendances < ActiveRecord::Migration
  def change
    rename_column :attendances, :user_id, :employee_id
  end
end
