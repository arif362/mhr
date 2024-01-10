#module Attendance
module Attendance::DayOffsHelper
  def hide_for_holiday(dayoff_type)
    unless dayoff_type == Attendance::DayOff::DAYOFF_TYPE[:custom_holiday]
      'dayoff_hour'
    end
  end
end
#end