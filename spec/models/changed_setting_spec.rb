# == Schema Information
#
# Table name: changed_settings
#
#  id            :integer          not null, primary key
#  open_time     :time
#  close_time    :time
#  working_hours :float(24)
#  from_date     :date
#  to_date       :date
#  department_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe ChangedSetting, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
