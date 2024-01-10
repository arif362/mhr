class ProvidentFund::RulesController < ApplicationController
  before_filter :current_ability

  def index
    @rules = current_department.provident_fund_rules
  end

  def new
    @rule = ProvidentFund::Rule.new
    respond_to do |format|
      format.js {}
      format.html {}
    end
  end

  def create
    @rule = ProvidentFund::Rule.new(rule_params.merge(department_id: current_department.id))
    respond_to do |format|
      format.html do
        if @rule.save
          redirect_to provident_fund_rules_path, success: 'Rule has been created successfully'
        else
          render :new
        end
      end
    end
  end

  def edit
    @rule = current_department.provident_fund_rules.find_by_id(params[:id])
    unless @rule.present?
      redirect_to provident_fund_rules_path, error: 'Provident fund rule not found'
    end
  end

  def update
    @rule = current_department.provident_fund_rules.find_by_id(params[:id])
    if @rule.present?
      if @rule.update_attributes(rule_params)
        redirect_to provident_fund_rules_path, success: 'Rule has been updated successfully'
      else
        render :edit
      end
    else
      redirect_to provident_fund_rules_path, error: 'Provident fund rule not found'
    end
  end

  def destroy
    @rule = current_department.provident_fund_rules.find_by_id(params[:id])
    if @rule.present?
      if @rule.destroy
        redirect_to provident_fund_rules_path, success: 'Rule has been deleted successfully'
      else
        redirect_to provident_fund_rules_path, error: 'Unable to delete rule, Please try again!'
      end
    else
      redirect_to provident_fund_rules_path, error: 'Provident fund rule not found'
    end
  end

  protected

  def rule_params
    params.require(:provident_fund_rule).permit!
  end

end
