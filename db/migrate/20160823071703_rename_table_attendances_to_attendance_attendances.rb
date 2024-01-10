class RenameTableAttendancesToAttendanceAttendances < ActiveRecord::Migration
  def change
    rename_table :attendances, :attendance_attendances
  end
end
