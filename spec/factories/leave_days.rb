# == Schema Information
#
# Table name: leave_days
#
#  id                   :integer          not null, primary key
#  day                  :date
#  leave_application_id :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  is_approved          :boolean          default(FALSE)
#

require 'faker'

FactoryGirl.define do
  factory :leave_days, class: Leave::Day do
    day Faker::Date.forward(5)
    is_approved false
  end
end
