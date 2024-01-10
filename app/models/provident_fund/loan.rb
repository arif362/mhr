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

class ProvidentFund::Loan < ActiveRecord::Base
  belongs_to :department
  belongs_to :provident_fund_account, :class_name => 'ProvidentFund::Account', foreign_key: :pf_account_id
  has_many :provident_fund_loan_returns, :class_name => 'ProvidentFund::LoanReturn', foreign_key: :loan_id, dependent: :destroy
  has_one :provident_fund_transaction, :class_name => 'ProvidentFund::Transaction', as: :transable

  # Callbacks
  validates_presence_of :pf_account_id, :amount, :description, :return_policy, :date, :return_date
  after_save :pf_transaction
  after_destroy :remove_pf_transaction

  def returned
    self.provident_fund_loan_returns.sum(:amount)
  end

  def debit_credit
    {
        debit: self.amount,
        credit: '-',
        balance: self.amount
    }
  end

  def pf_transaction
    transaction = self.provident_fund_transaction
    transaction = transaction.present? ? transaction : self.build_provident_fund_transaction
    transaction.debit = self.amount
    transaction.pf_account_id = self.pf_account_id
    transaction.department_id = self.department_id
    transaction.save
  end

  def self.loan_search(pf_account_id, status, current_department)
    if pf_account_id.present?
      if status.present? && status == Employees::AdvanceReturn::STATUS[:all]
        provident_fund_loans = current_department.provident_fund_loans.where(pf_account_id: pf_account_id)
      else
        loan_status = status == Employees::AdvanceReturn::STATUS[:completed] ? true : false
        provident_fund_loans = current_department.provident_fund_loans.where(pf_account_id: pf_account_id, is_closed: loan_status)
      end

    else
      if status.present? && status == Employees::AdvanceReturn::STATUS[:all]
        provident_fund_loans = current_department.provident_fund_loans
      else
        loan_status = status == Employees::AdvanceReturn::STATUS[:completed] ? true : false
        provident_fund_loans = current_department.provident_fund_loans.where(is_closed: loan_status)
      end
    end
  end

  def remove_pf_transaction
    self.provident_fund_transaction.delete_all  if self.provident_fund_transaction.present?
  end

end
