# == Schema Information
#
# Table name: departments
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text(65535)
#  image       :string(255)
#  company_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  address     :text(65535)
#  slug        :string(255)
#  city        :string(255)
#  state       :string(255)
#  zip_code    :string(255)
#  country     :string(255)
#  email       :string(255)
#  mobile      :string(255)
#

require 'faker'

FactoryGirl.define do
  factory :department do
    name Faker::Company.name
    description Faker::Lorem.paragraph
  end
end
