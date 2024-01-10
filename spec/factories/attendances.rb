require 'faker'

FactoryGirl.define do
  factory :attendance, class: Attendance::Attendance do
    in_date Date.today
    in_time Date.today.to_s + " 09:00:00"
    out_time Date.today.to_s + " 12:00:00"
    duration 10800
  end
end
