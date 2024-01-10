# == Schema Information
#
# Table name: provident_fund_loan_returns
#
#  id            :integer          not null, primary key
#  date          :date
#  amount        :float(24)
#  department_id :integer
#  loan_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do
  factory :provident_fund_loan_return, class: 'ProvidentFund::LoanReturn' do
    amount 500
    date Date.today.beginning_of_month
  end
end
