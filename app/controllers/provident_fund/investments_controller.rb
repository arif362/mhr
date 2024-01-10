class ProvidentFund::InvestmentsController < ApplicationController
  before_filter :current_ability

  def index
    @provident_fund_investments = current_department.provident_fund_investments
  end

  def new
    @provident_fund_investment = current_department.provident_fund_investments.build
  end

  def create
    @provident_fund_investment = current_department.provident_fund_investments.build(investment_params)
    respond_to do |format|
      if @provident_fund_investment.save
        redirect_to provident_fund_investments_path, success: 'Investment created successfully' and return
      else
        render 'new'
      end
    end
  end

  def edit
    @provident_fund_investment = current_department.provident_fund_investments.find_by_id(params[:id])
  end

  def update
    @provident_fund_investment = current_department.provident_fund_investments.find_by_id(params[:id])
    unless @provident_fund_investment.present?
      redirect_to provident_fund_investments_path, error: 'Unable to update investment'
    end
    respond_to do |format|
      if @provident_fund_investment.update_attributes(investment_params)
        redirect_to provident_fund_investments_path, success: 'Investment updated successfully' and return
      else
        render 'edit'
      end
    end
  end

  def destroy
    provident_fund_investment = current_department.provident_fund_investments.find_by_id(params[:id])
    unless provident_fund_investment.present?
      redirect_to provident_fund_investments_path, error: 'Unable to update investment' and return
    end
    respond_to do |format|
      if provident_fund_investment.destroy
        redirect_to provident_fund_investments_path, success: 'Investment deleted successfully' and return
      else
        redirect_to provident_fund_investments_path, error: 'Unable to delete investment' and return
      end
    end
  end

  private

  def investment_params
    params.require(:provident_fund_investment).permit!
  end
end

