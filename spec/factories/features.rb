# == Schema Information
#
# Table name: features
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  cost        :float(24)
#  description :text(65535)
#  app_module  :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  url         :string(255)
#  logo        :string(255)
#

require 'faker'

FactoryGirl.define do
  factory :feature do
    name Faker::Lorem.name
    cost Faker::Number.number(5)
    description Faker::Lorem.sentences
    app_module Faker::Lorem.word
  end
end
