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

class ProvidentFund::Transaction < ActiveRecord::Base
  belongs_to :transable, :polymorphic => true
  belongs_to :provident_fund_account, :class_name => 'ProvidentFund::Account', foreign_key: :pf_account_id
  belongs_to :department

  def self.initial_balance(date)
    self.where('DATE(updated_at) < ?', date).map(&:amount).sum
  end

  def amount
    (self.credit || 0) - (self.debit || 0)
  end

  def self.filter(start_date, end_date)
    where('DATE(updated_at) >= ? and DATE(updated_at) <= ?', start_date, end_date)
  end

end
