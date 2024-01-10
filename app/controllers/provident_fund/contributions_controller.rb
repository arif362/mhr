class ProvidentFund::ContributionsController < ApplicationController
  before_filter :current_ability

  def index
    @account = current_department.provident_fund_accounts.find_by_id(params[:account_id])
    unless @account.present?
      redirect_to provident_fund_accounts_path, error: 'Account not found'
    end
    @contributions = @account.contributions
  end


  def employee_contributions
    @contributions = ProvidentFund::Contribution.search(current_department.id, params)
  end

  def process_contribution
    year = params[:year] || Time.now.year
    month = params[:month] || Time.now.month
    accounts = current_department.provident_fund_accounts - ProvidentFund::Account.joins(:contributions).where('year = ? and month = ? and department_id = ?', year, month, current_department.id)
    accounts.each do |account|
      employee = account.employee
      basic_salary = employee.basic_salary
      unless basic_salary.present?
        flash[:danger] = 'Some contribution processing failed due to lack of employee basic salary. Please set their basic salary then process their contribution manually!'
        next
      end
      rule = account.rule
      company_contribution = basic_salary * (rule.company_contribution.to_f / 100)
      employee_contribution = basic_salary * (rule.employee_contribution.to_f / 100)
      contribution = account.contributions.build(company_contribution: company_contribution, employee_contribution: employee_contribution, basis_salary: basic_salary, year: year, month: month)
      contribution.save
    end
    redirect_to employee_contributions_provident_fund_contributions_path
  end

  def confirm
    contributions = ProvidentFund::Contribution.unconfirmed_contributions(current_department.id)
    contributions.each do |contribution|
      if params[:contributions].include? contribution.id.to_s
        contribution.update_attribute(:is_confirmed, true)
      end
    end

    render nothing: true
  end

  def edit
    @account = ProvidentFund::Account.find_by_id(params[:account_id])
    @contribution = @account.contributions.find_by_id(params[:id]) if @account.present?
    unless @contribution.present?
      redirect_to provident_fund_rules_path, error: 'Provident fund rule not found'
    end
  end

  def update
    @account = ProvidentFund::Account.find_by_id(params[:account_id])
    @contribution = @account.contributions.find_by_id(params[:id]) if @account.present?
    if @contribution.present? && @contribution.save
      redirect_to edit_provident_fund_account_contribution_path(@account, @contribution), success: 'Provident fund contribution has been updated successfully'
    else
      render :edit
      #redirect_to provident_fund_rules_path, error: 'Failed to update provident fund contribution'
    end
  end

end
