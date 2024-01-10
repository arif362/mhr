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

class ProvidentFund::Investment < ActiveRecord::Base
  belongs_to :department
  has_many :provident_fund_transactions, :class_name => 'ProvidentFund::Transaction', as: :transable, dependent: :destroy

  after_save :pf_transaction
  after_destroy :pf_transaction
  validates_presence_of :title,:pf_type,:amount,:interest_rate,:no_year,:date,:maturity_date

  def pf_transaction
    transaction = self.provident_fund_transactions.first
    transaction = transaction.present? ? transaction : self.provident_fund_transactions.build
    transaction.debit = self.amount
    transaction.department_id = self.department_id
    transaction.save
  end

  def remove_pf_transaction
    self.provident_fund_transactions.destroy_all
  end

end
