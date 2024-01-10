FactoryGirl.define do
  factory :category, class: Community::Category do
    title Faker::Lorem.sentence
  end
end
