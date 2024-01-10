class ProvidentFund::LoanReturnsController < ApplicationController
  before_filter :current_ability

  def index

  end

  def new

  end

  def return_form
    @provident_fund_loan_return = ProvidentFund::LoanReturn.new
    pf_account = ProvidentFund::Account.find_by_id(params[:pf_account_id])
    if pf_account.present?
      @loans = pf_account.provident_fund_loans.where(is_closed: false)
    else
      @loans = []
    end
  end

  def create
    loan = current_department.provident_fund_loans.find_by_id(loan_return_params[:loan_id])
    loan_return = ProvidentFund::LoanReturn.create(loan_return_params)
    if loan.provident_fund_loan_returns && loan_return
      if loan_return.save
      incomplete_loan = loan_return.provident_fund_loan
        return_amount = incomplete_loan.provident_fund_loan_returns.sum(:amount)
        if incomplete_loan.amount <= return_amount
          incomplete_loan.update(is_closed: true)
        end
      redirect_to provident_fund_loans_path, success: 'Provident fund loan return success'
      else
        redirect_to provident_fund_loans_path, success: 'Provident fund loan return failed'
      end
    else
      render :new, success: 'Provident fund loan return success'
    end
  end

  def show

  end

  def edit

  end

  def update

  end

  def delete

  end

  private

  def loan_return_params
    params.require(:provident_fund_loan_return).permit!
  end
end

