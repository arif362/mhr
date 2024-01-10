# == Schema Information
#
# Table name: provident_fund_accounts
#
#  id             :integer          not null, primary key
#  number         :string(255)
#  rule_id        :integer
#  employee_id    :integer
#  effective_date :date
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  department_id  :integer
#

FactoryGirl.define do
  factory :provident_fund_account, class: 'ProvidentFund::Account' do
    number "MyString"
    rule_id 1
    employee_id 1
    effective_date "2016-12-21"
  end
end
