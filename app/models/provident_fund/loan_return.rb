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

class ProvidentFund::LoanReturn < ActiveRecord::Base
  belongs_to :department
  belongs_to :provident_fund_loan, :class_name => 'ProvidentFund::Loan', foreign_key: :loan_id
  has_one :provident_fund_transaction, :class_name => 'ProvidentFund::Transaction', as: :transable

  # Callbacks

  after_save :pf_transaction
  after_destroy :remove_pf_transaction

  validates_presence_of :amount, :date

  def debit_credit
    {
        debit: '-',
        credit: self.amount,
        balance: -(self.amount)
    }
  end

  def pf_transaction
    transaction = self.provident_fund_transaction
    transaction = transaction.present? ? transaction : self.build_provident_fund_transaction
    transaction.credit = self.amount
    transaction.pf_account_id = self.provident_fund_loan.pf_account_id
    transaction.department_id = self.department_id
    transaction.save
  end

  def remove_pf_transaction
    self.provident_fund_transaction.delete_all if self.provident_fund_transaction.present?
  end

end
