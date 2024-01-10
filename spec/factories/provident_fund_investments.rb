# == Schema Information
#
# Table name: provident_fund_investments
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  pf_type       :string(255)
#  amount        :string(255)
#  maturity_date :date
#  no_year       :float(24)
#  date          :date
#  interest_rate :float(24)
#  no_day        :integer
#  department_id :integer
#  active        :boolean          default(TRUE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do
  factory :provident_fund_investment, class: 'ProvidentFund::Investment' do
    title Faker::Lorem.sentence
    pf_type Faker::Lorem.sentence
    amount 5000
    interest_rate 5
    no_year 5
    date Date.today
    maturity_date '2022-12-25'
  end
end
