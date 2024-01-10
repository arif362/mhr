require 'faker'

FactoryGirl.define do
  factory :expenses_category, class: Expenses::Category do
    name Faker::Name.name
    description Faker::Lorem.sentences
  end
end
