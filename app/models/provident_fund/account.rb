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

class ProvidentFund::Account < ActiveRecord::Base
  belongs_to :employee
  belongs_to :rule, :class_name => 'ProvidentFund::Rule'
  belongs_to :department
  has_many :contributions, :class_name => 'ProvidentFund::Contribution', foreign_key: :provident_fund_account_id, dependent: :destroy
  has_many :provident_fund_loans, :class_name => 'ProvidentFund::Loan', foreign_key: :pf_account_id, dependent: :destroy
  has_many :provident_fund_transactions, :class_name => 'ProvidentFund::Transaction', foreign_key: :pf_account_id, dependent: :destroy

  validates :rule_id, :presence => true
end
