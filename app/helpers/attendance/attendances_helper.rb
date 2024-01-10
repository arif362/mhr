module Attendance
  module AttendancesHelper
    def total_attend_employee(attendance_date)
      current_department.attendances.where(in_date: attendance_date).distinct.count(:employee_id)
    end
  end
end
