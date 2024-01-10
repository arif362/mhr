class ProvidentFundController < ApplicationController
  before_filter :current_ability

  def dashboard
    @unconfirmed_contributions = ProvidentFund::Contribution.unconfirmed_contributions(current_department.id)
    contributions = ProvidentFund::Contribution.search(current_department.id)
    @employee_contributions = contributions.group('provident_fund_accounts.employee_id').sum(:employee_contribution)
    @company_contributions = contributions.group('provident_fund_accounts.employee_id').sum(:company_contribution)
    @process_contribution = true
  end

  def statement
    @end_date = Date.today
    @start_date = @end_date - 6.months

    if params[:daterange].present?
      date_range = params[:daterange].split('To')
      @start_date = Date.parse(date_range.first)
      @end_date = Date.parse(date_range.last)
    end
    @balance = ProvidentFund::Transaction.where(department_id: current_department.id).initial_balance(@start_date)
    @statements = ProvidentFund::Transaction.where(department_id: current_department.id).filter(@start_date, @end_date)
  end

end
