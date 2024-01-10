# == Schema Information
#
# Table name: settings
#
#  id            :integer          not null, primary key
#  open_time     :time
#  close_time    :time
#  working_hours :float(24)
#  department_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  time_zone     :string(255)      default("UTC")
#  currency      :string(255)
#

class Setting < ActiveRecord::Base
  belongs_to :department
end
