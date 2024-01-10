# == Schema Information
#
# Table name: attendance_day_offs
#
#  id            :integer          not null, primary key
#  year          :integer
#  date          :date
#  day_off_type  :string(255)
#  hours         :float(24)
#  title         :string(255)
#  department_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'faker'

FactoryGirl.define do
  factory :attendance_day_off, class: Attendance::DayOff do
    date Date.today
    day_off_type AppSettings::DAYOFF_TYPES[:holiday]
    title Faker::Lorem.sentence
  end
end
