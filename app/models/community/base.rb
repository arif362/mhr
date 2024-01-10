module Community
  class Base < ActiveRecord::Base
    self.abstract_class = true
    self.table_name_prefix = 'community_'
  end
end
