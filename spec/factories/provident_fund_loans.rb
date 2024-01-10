# == Schema Information
#
# Table name: provident_fund_loans
#
#  id            :integer          not null, primary key
#  pf_account_id :integer
#  department_id :integer
#  amount        :float(24)
#  description   :text(65535)
#  return_policy :string(255)
#  installment   :integer
#  return_date   :date
#  date          :date
#  is_closed     :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do
  factory :provident_fund_loan, class: 'ProvidentFund::Loan' do
    amount 500
    description 'loan'
    return_policy 'On Request'
    date Date.today
    return_date Date.today.at_end_of_day
  end
end
