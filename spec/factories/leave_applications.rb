# == Schema Information
#
# Table name: leave_applications
#
#  id                :integer          not null, primary key
#  message           :text(65535)
#  note              :text(65535)
#  attachment        :string(255)
#  employee_id       :integer
#  leave_category_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  department_id     :integer
#  total_days        :integer
#  is_approved       :boolean          default(FALSE)
#  status            :string(255)      default("pending")
#  is_paid           :boolean          default(FALSE)
#

require 'faker'

FactoryGirl.define do
  factory :leave_application, :class => Leave::Application do
    message Faker::Lorem.paragraph
    note Faker::Lorem.sentence
    total_days 5
    is_approved false
  end
end
