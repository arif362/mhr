class CreateAttendanceAttendanceLogs < ActiveRecord::Migration
  def change
    create_table :attendance_attendance_logs do |t|
      t.string :ip_address
      t.integer :attendance_id

      t.timestamps null: false
    end
  end
end
