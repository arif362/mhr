module Employees
  class Base < ActiveRecord::Base
    self.abstract_class = true
    self.table_name_prefix = 'employees_'
  end
end