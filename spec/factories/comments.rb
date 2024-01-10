FactoryGirl.define do
  factory :comment, class: Community::Comment do
    content Faker::Lorem.sentences
  end
end
