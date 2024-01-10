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

require 'faker'

FactoryGirl.define do
  factory :setting do
    open_time "10:00:00"
    close_time "18:00:00"
    working_hours 8
  end
end
