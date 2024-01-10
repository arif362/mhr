# == Schema Information
#
# Table name: bank_accounts
#
#  id            :integer          not null, primary key
#  department_id :integer
#  name          :string(255)
#  number        :string(255)
#  bank_name     :string(255)
#  bank_branch   :string(255)
#  balance       :float(24)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do
  factory :bank_account, class: 'Bank::Account' do
    name Faker::Name.name
    # bank_name Faker::Bank.name
    number Faker::Number.number(10)
  end
end
