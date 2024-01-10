class ProvidentFund::LoansController < ApplicationController
  before_filter :current_ability
  before_action :load_loan_history, only: [:history]

  def index
    @provident_fund_loans = ProvidentFund::Loan.loan_search(params[:pf_account_id], params[:status], current_department)
  end

  def new
    @provident_fund_loan = current_department.provident_fund_loans.build
  end

  def create
    @provident_fund_loan = current_department.provident_fund_loans.build(loan_params)
    respond_to do |format|
      if @provident_fund_loan.save
        redirect_to provident_fund_loans_path, success: 'Loan created successfully' and return
      else
        render 'new'
      end
    end
  end

  def show
    @provident_fund_loan = current_department.provident_fund_loans.find_by_id(params[:id])
    load_loan_history(@provident_fund_loan.pf_account_id)
  end

  def edit
    @provident_fund_loan = current_department.provident_fund_loans.find_by_id(params[:id])
  end

  def update
    @provident_fund_loan = current_department.provident_fund_loans.find_by_id(params[:id])
    unless @provident_fund_loan.present?
      redirect_to provident_fund_loans_path, error: 'Unable to update loan'
    end
    respond_to do |format|
      if @provident_fund_loan.update_attributes(loan_params)
        redirect_to provident_fund_loans_path, success: 'Loan updated successfully' and return
      else
        render 'edit'
      end
    end
  end

  def history
    respond_to do |format|
      format.js {}
    end
  end

  def destroy
    provident_fund_loan = current_department.provident_fund_loans.find_by_id(params[:id])
    unless provident_fund_loan.present?
      redirect_to provident_fund_loans_path, error: 'Unable to update loan' and return
    end
    respond_to do |format|
      if provident_fund_loan.destroy
        redirect_to provident_fund_loans_path, success: 'Loan deleted successfully' and return
      else
        redirect_to provident_fund_loans_path, error: 'Unable to delete loan' and return
      end
    end
  end

  private

  def load_loan_history(pf_account_id = nil)
    account_id = pf_account_id.present? ? pf_account_id : params[:pf_account_id]
    pf_account = current_department.provident_fund_accounts.find_by_id(account_id)
    @history = pf_account.provident_fund_transactions
  end

  def loan_params
    params.require(:provident_fund_loan).permit!
  end
end

