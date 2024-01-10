class ProvidentFund::AccountsController < ApplicationController
  before_filter :current_ability

  def index
    @accounts = ProvidentFund::Account.joins(:employee).where('employees.department_id = ?', current_department.id)
  end

  def new
    @account = ProvidentFund::Account.new
    @non_account_employee = current_department.employees.active - Employee.joins(:provident_fund_account).where(department_id: current_department.id)
  end

  def create
    account = ProvidentFund::Account.new(account_params.merge(department_id: current_department.id))
    respond_to do |format|
      format.html do
        if account.save
          redirect_to provident_fund_accounts_path, success: 'Rule has been created successfully'
        else
          redirect_to new_provident_fund_account_path, error: 'unable to connect PF account, Please try again! '
        end
      end
    end
  end

  def edit
    @account = ProvidentFund::Account.find_by_id(params[:id])
  end

  def update
    @account = ProvidentFund::Account.find_by_id(params[:id])
    if @account.present?
      if @account.update_attributes(account_params)
        redirect_to provident_fund_accounts_path, success: 'Account has been updated successfully'
      else
        render :edit
      end
    else
      redirect_to provident_fund_accounts_path, error: 'Provident fund account not found'
    end
  end

  def destroy
    @account = ProvidentFund::Account.find_by_id(params[:id])
    if @account.present?
      if @account.destroy
        redirect_to provident_fund_accounts_path, success: 'Account has been deleted successfully'
      else
        redirect_to provident_fund_accounts_path, error: 'Unable to delete account, Please try again!'
      end
    else
      redirect_to provident_fund_accounts_path, error: 'Provident fund account not found'
    end
  end

  def statement
    @pf_account = current_department.provident_fund_accounts.find_by_id(params[:account_id])
    unless @pf_account.present?
      redirect_to provident_fund_accounts_path, error: 'PF account not found'
    end
    @employee = @pf_account.employee
    @statements = @pf_account.provident_fund_transactions
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: 'PF Account Statement', layout: 'pdf', template: 'provident_fund/accounts/statement_pdf.html.erb', encoding: 'utf-8'
      end
      format.xls
      format.docx do
        render docx: 'Expenses docx', template: 'expenses/expenses/expenses_xls_docx.html.erb', encoding: 'utf-8'
      end
    end
  end

  def employee
    @employee = Employee.find_by_id(params[:employee_id])
  end

  private

  def account_params
    params.require(:provident_fund_account).permit!
  end

end
