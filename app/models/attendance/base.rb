# module Attendance
class Attendance::Base < ActiveRecord::Base
  self.abstract_class = true
  self.table_name_prefix = 'attendance_'
end
# end