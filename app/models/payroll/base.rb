module Payroll
  class Base < ActiveRecord::Base
    self.abstract_class = true
    self.table_name_prefix = 'payroll_'
  end
end
