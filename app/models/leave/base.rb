module Leave
  class Base < ActiveRecord::Base
    self.abstract_class = true
    self.table_name_prefix = 'leave_'
  end
end