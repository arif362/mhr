# == Schema Information
#
# Table name: provident_fund_contributions
#
#  id                        :integer          not null, primary key
#  provident_fund_account_id :integer
#  basis_salary              :float(24)
#  employee_contribution     :float(24)
#  company_contribution      :float(24)
#  month                     :integer
#  year                      :integer
#  is_confirmed              :boolean          default(FALSE)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

class ProvidentFund::Contribution < ActiveRecord::Base
  belongs_to :provident_fund_account, :class_name => 'ProvidentFund::Account', foreign_key: :provident_fund_account_id
  has_one :provident_fund_transaction, :class_name => 'ProvidentFund::Transaction', as: :transable
  after_save :pf_transaction
  after_destroy :remove_pf_transaction

  def self.search(department_id, params = {})
    if params[:commit].present?
      joins(:provident_fund_account).where('year = ? and month = ? and provident_fund_accounts.department_id = ?', params[:year], params[:month], department_id)
    else
      joins(:provident_fund_account).where('provident_fund_accounts.department_id = ?', department_id)
    end
  end

  def self.unconfirmed_contributions(department)
    joins(:provident_fund_account).where('provident_fund_accounts.department_id = ? and is_confirmed = false', department)
  end

  def pf_transaction
    transaction = self.provident_fund_transaction
    transaction = transaction.present? ? transaction : self.build_provident_fund_transaction
    transaction.credit = (self.employee_contribution || 0) + (self.company_contribution || 0)
    transaction.pf_account_id = self.provident_fund_account_id
    transaction.department_id = self.provident_fund_account.department_id
    transaction.save
  end

  def remove_pf_transaction
    self.provident_fund_transaction.delete if self.provident_fund_transaction.present?
  end

end
