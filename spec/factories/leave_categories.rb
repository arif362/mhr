# == Schema Information
#
# Table name: leave_categories
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  department_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  description   :text(65535)
#  is_active     :boolean          default(TRUE)
#

require 'faker'

FactoryGirl.define do
  factory :leave_category, :class => Leave::Category do
    name Faker::Name.name
  end
end
