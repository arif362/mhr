# == Schema Information
#
# Table name: provident_fund_contributions
#
#  id                        :integer          not null, primary key
#  provident_fund_account_id :integer
#  basis_salary              :float(24)
#  employee_contribution     :float(24)
#  company_contribution      :float(24)
#  month                     :integer
#  year                      :integer
#  is_confirmed              :boolean          default(FALSE)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

FactoryGirl.define do
  factory :provident_fund_contribution, class: 'ProvidentFund::Contribution' do
    provident_fund_account_id 1
    basis_salary 1.5
    employee_contribution 1.5
    company_contribution 1.5
    month 1
    year 1
  end
end
