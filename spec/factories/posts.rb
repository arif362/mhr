FactoryGirl.define do
  factory :post, class: Community::Post do
    title Faker::Lorem.sentence
  end
end
