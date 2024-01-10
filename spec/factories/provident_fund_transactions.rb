# == Schema Information
#
# Table name: provident_fund_transactions
#
#  id             :integer          not null, primary key
#  transable_type :string(255)
#  transable_id   :integer
#  debit          :float(24)
#  credit         :float(24)
#  pf_account_id  :float(24)
#  department_id  :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryGirl.define do
  factory :provident_fund_transaction, class: 'ProvidentFund::Transaction' do
    transabletype "MyString"
    transableid 1
    debit 1.5
    credit 1.5
    balance 1.5
    department_id 1
  end
end
