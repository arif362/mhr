# == Schema Information
#
# Table name: provident_fund_rules
#
#  id                    :integer          not null, primary key
#  company_contribution  :float(24)
#  employee_contribution :string(255)
#  department_id         :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

FactoryGirl.define do
  factory :provident_fund_rule, class: 'ProvidentFund::Rule' do
    company_contribution 1.5
    employee_contribution "MyString"
    department_id 1
  end
end
