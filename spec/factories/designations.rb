# == Schema Information
#
# Table name: designations
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  description   :text(65535)
#  is_active     :boolean          default(FALSE)
#  department_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'faker'

FactoryGirl.define do
  factory :designation do
    name Faker::Name.name
    description Faker::Lorem.sentence
    is_active true
  end
end
