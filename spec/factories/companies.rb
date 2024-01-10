# == Schema Information
#
# Table name: companies
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  image         :string(255)
#  employee_id   :integer
#  mobile        :string(255)
#  contact_email :string(255)
#  address       :string(255)
#  city          :string(255)
#  state         :string(255)
#  zip_code      :string(255)
#  country       :string(255)
#  next_path     :string(255)
#  custom_url    :string(255)
#  url           :string(255)
#

require 'faker'

FactoryGirl.define do
  factory :company do
    name Faker::Company.name
    mobile Faker::PhoneNumber.phone_number
    address Faker::Address.secondary_address
    city Faker::Address.city
    state Faker::Address.state
    zip_code Faker::Address.zip_code
    country Faker::Address.country
    next_path ''
  end
end
