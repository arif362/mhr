# == Schema Information
#
# Table name: provident_fund_rules
#
#  id                    :integer          not null, primary key
#  company_contribution  :float(24)
#  employee_contribution :string(255)
#  department_id         :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'rails_helper'

RSpec.describe ProvidentFund::RulesController, type: :controller do

  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id:@company.id)
    @employee = FactoryGirl.create(:employee, role:Employee::ROLE[:admin], department_id:@department.id)
    @provident_fund_rule = FactoryGirl.create(:provident_fund_rule, department_id:@department.id)
    session[:department_id] = @department.id
    sign_in(@employee)
  end

  describe 'get# index' do
    it 'should request to index action' do
      get :index
      expect(response).to be_success
    end
  end

  describe 'get#new' do
    it 'should request to new action' do
      get :new
      expect(response).to be_success
    end
    it 'should request to new action' do
      xhr :get, :new, format: :js
      expect(response).to be_success
    end
    it 'should assign a newly rule' do
      get :new
      expect(assigns(:rule)).to be_a_new(ProvidentFund::Rule)
    end
    it 'should assign a newly rule' do
      xhr :get, :new, format: :js
      expect(assigns(:rule)).to be_a_new(ProvidentFund::Rule)
    end
  end

  describe 'post#create' do
    context 'when provident_fund_rule saved' do
      it 'should request to create action' do
        post :create, provident_fund_rule: {company_contribution:2.5,employee_contribution:2.5}
        expect(response).to redirect_to(provident_fund_rules_path)
      end
      it 'should increment by 1' do
        count = ProvidentFund::Rule.count
        post :create, provident_fund_rule: {company_contribution:2.5,employee_contribution:2.5}
        expect(ProvidentFund::Rule.count).to eq(count+1)
      end
    end

    context 'when provident_fund_rule not saved' do
      it 'should request to create action' do
        post :create, provident_fund_rule: {company_contribution:nil,employee_contribution:nil}
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'get #edit' do
    context 'when @rule present' do
      it 'should request to edit action' do
        get :edit, id:@provident_fund_rule.id
        expect(response).to be_success
      end
    end
    context 'when @rule not present' do
      it 'should request to edit action' do
        get :edit, id:@provident_fund_rule.id+1
        expect(response).to redirect_to(provident_fund_rules_path)
      end
    end
  end

  describe 'put # update' do
    context 'when @rule present' do
      context 'if attributes of rule updated' do
        it 'should request to update action' do
          put :update, id:@provident_fund_rule.id, provident_fund_rule: {company_contribution:3.5,employee_contribution:3.5}
          expect(response).to redirect_to(provident_fund_rules_path)
        end
      end
      context 'if attributes of rule not updated' do
        it 'should request to update action' do
          put :update, id:@provident_fund_rule.id, provident_fund_rule: {company_contribution:nil,employee_contribution:3.5}
          expect(response).to render_template(:edit)
        end
      end
    end
    context 'when @rule not present' do
      it 'should request to update action' do
        put :update, id:76
        expect(response).to redirect_to(provident_fund_rules_path)
      end
    end
  end
  describe 'delete # destroy' do
    context 'when @rule not present' do
      it 'should request to destroy action' do
        delete :destroy, id:@provident_fund_rule.id+1
        expect(response).to redirect_to(provident_fund_rules_path)
      end
    end
    context 'when @rule present' do
      context 'if destroyed' do
        it 'should request to destroy action' do
          delete :destroy, id:@provident_fund_rule.id
          expect(response).to redirect_to(provident_fund_rules_path)
        end
      end
      # context 'if not destroyed' do
      #   it 'should request to destroy action' do
      #     delete :destroy, id:@provident_fund_rule.id
      #     expect(response).to redirect_to(provident_fund_rules_path)
      #   end
      # end

    end

  end

end
