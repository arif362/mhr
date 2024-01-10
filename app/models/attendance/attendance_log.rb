class Attendance::AttendanceLog < ActiveRecord::Base
  belongs_to :attendance_attendance, :class_name => 'Attendance::Attendance'
end
