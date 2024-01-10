# == Schema Information
#
# Table name: company_features
#
#  id         :integer          not null, primary key
#  feature_id :integer
#  company_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'faker'

FactoryGirl.define do
  factory :company_feature do
    
  end
end
