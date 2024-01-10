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

require 'rails_helper'

RSpec.describe ProvidentFund::ContributionsController, type: :controller do

  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id: @company.id)
    @employee = FactoryGirl.create(:employee, role: Employee::ROLE[:admin], basic_salary: 30000, department_id: @department.id)
    @rule = FactoryGirl.create(:provident_fund_rule)
    @provident_fund_account = FactoryGirl.create(:provident_fund_account, employee_id: @employee.id, rule_id: @rule.id, department_id: @department.id)
    @provident_fund_contribution = FactoryGirl.create(:provident_fund_contribution, provident_fund_account_id: @provident_fund_account.id)
    session[:department_id] = @department.id
    sign_in(@employee)
  end

  describe 'get#index' do
    context 'if @account present' do
      it 'should request to index of ContributionsController' do
        get :index, account_id: @provident_fund_account.id
        expect(response).to be_success
      end
      it 'should assign the account' do
        get :index, account_id: @provident_fund_account.id
        expect(assigns(:account)).to eq(@provident_fund_account)
      end
      it 'should assign the @contributions' do
        get :index, account_id: @provident_fund_account.id
        expect(assigns(:contributions)).to eq([@provident_fund_contribution])
      end
    end
    context 'if @account not present' do
      it 'should request to index of ContributionsController' do
        get :index, account_id: @provident_fund_account.id + 1
        expect(response).to redirect_to(provident_fund_accounts_path)
      end
    end
  end

  describe 'get#employee_contributions' do
    it 'should request to employee_contributions of ContributionsController' do
      get :employee_contributions
      expect(response).to be_success
    end
    it 'should assign @contributions' do
      get :employee_contributions
      expect(assigns(:contributions)).to eq([@provident_fund_contribution])
    end
  end

  describe 'get#process_contribution' do
    it 'should request to process_contribution' do
      get :process_contribution
      expect(response).to redirect_to(employee_contributions_provident_fund_contributions_path)
    end
  end

  describe 'get#confirm' do
    it 'should request to confirm' do
      get :confirm, contributions: 1, provident_fund_contribution: {is_confirmed: true}
      expect(response).to be_success
    end
  end

  describe 'get#edit' do
    context 'if @contribution present' do
      it 'should request to edit' do
        get :edit, account_id: @provident_fund_account.id, id: @provident_fund_contribution.id
        expect(response).to be_success
      end
      it 'should assign @account' do
        get :edit, account_id: @provident_fund_account.id, id: @provident_fund_contribution.id
        expect(assigns(:account)).to eq(@provident_fund_account)
      end
      it 'should assign @contribution' do
        get :edit, account_id: @provident_fund_account.id, id: @provident_fund_contribution.id
        expect(assigns(:contribution)).to eq(@provident_fund_contribution)
      end
    end
    context 'if @contribution not present' do
      it 'should request to edit' do
        get :edit, account_id: @provident_fund_account.id, id: @provident_fund_contribution.id + 1
        expect(response).to redirect_to(provident_fund_rules_path)
      end
    end
  end

  describe 'put#update' do
    context 'if @contribution.present? && @contribution.save' do
      it 'should request to update action' do
        put :update, id: @provident_fund_contribution.id, account_id: @provident_fund_account.id
        expect(response).to redirect_to(edit_provident_fund_account_contribution_path(@provident_fund_account, @provident_fund_contribution))
      end
      it 'should assign @account' do
        put :update, id: @provident_fund_contribution.id, account_id: @provident_fund_account.id
        expect(assigns(:account)).to eq(@provident_fund_account)
      end
      it 'should assign @contribution' do
        put :update, id: @provident_fund_contribution.id, account_id: @provident_fund_account.id
        expect(assigns(:contribution)).to eq(@provident_fund_contribution)
      end
    end
    context 'if not @contribution.present? && @contribution.save' do
      it 'should request to update action' do
        put :update, id: @provident_fund_contribution.id + 1, account_id: @provident_fund_account.id
        expect(response).to render_template(:edit)
      end
    end
  end
end
