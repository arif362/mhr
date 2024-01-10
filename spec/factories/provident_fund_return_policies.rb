# == Schema Information
#
# Table name: provident_fund_return_policies
#
#  id                 :integer          not null, primary key
#  year               :float(24)
#  company_percentage :float(24)
#  rule_id            :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

FactoryGirl.define do
  factory :provident_fund_return_policy, class: 'ProvidentFund::ReturnPolicy' do
    year 1.5
    company_percentage 1.5
  end
end
