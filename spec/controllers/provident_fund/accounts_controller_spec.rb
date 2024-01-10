# == Schema Information
#
# Table name: provident_fund_accounts
#
#  id             :integer          not null, primary key
#  number         :string(255)
#  rule_id        :integer
#  employee_id    :integer
#  effective_date :date
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  department_id  :integer
#

require 'rails_helper'

RSpec.describe ProvidentFund::AccountsController, type: :controller do

  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id: @company.id)
    @employee = FactoryGirl.create(:employee, role: Employee::ROLE[:admin], department_id: @department.id)
    @rule = FactoryGirl.create(:provident_fund_rule)
    @account = FactoryGirl.create(:provident_fund_account, employee_id: @employee.id, rule_id: @rule.id, department_id: @department.id)
    session[:department_id]= @department.id
    sign_in(@employee)
  end

  describe 'get#index' do
    it 'should request to index of AccountsController' do
      get :index
      expect(response).to be_success
    end
  end

  describe 'get#new' do
    it 'should request to new action of AccountsController' do
      get :new
      expect(response).to be_success
    end
    it 'should request to new action of AccountsController' do
      get :new
      expect(assigns(:account)).to be_a_new(ProvidentFund::Account)
    end
    it 'should assign a non account employee' do
      @employee_non_account = FactoryGirl.create(:employee, department_id: @department.id)
      get :new
      expect(assigns(:non_account_employee)).to eq([@employee_non_account])
    end
  end

  describe 'post#create' do
    context 'if provident_fund_account saved' do
      it 'should request to create action of AccountsController' do
        post :create, provident_fund_account: {rule_id: 1}
        expect(response).to redirect_to(provident_fund_accounts_path)
      end
      it 'should assign the increment account' do
        count = ProvidentFund::Account.count
        post :create, provident_fund_account: {rule_id: 1}
        expect(ProvidentFund::Account.count).to eq(count+1)
      end
    end
    context 'if provident_fund_account not saved' do
      it 'should request to create action of AccountsController' do
        post :create, provident_fund_account: {rule_id: nil}
        expect(response).to redirect_to(new_provident_fund_account_path)
      end
    end
  end

  describe 'get#edit' do
    it 'should request to edit action of AccountsController' do
      get :edit, id: @account.id
      expect(response).to be_success
    end
    it 'should assign @account' do
      get :edit, id: @account.id
      expect(assigns(:account)).to eq(@account)
    end
  end

  describe 'get#update' do
    context ' if @account present' do
      context 'if @account updated' do
        it 'should request to edit action of AccountsController' do
          get :update, id: @account.id, provident_fund_account: {rule_id: 1}
          expect(response).to redirect_to(provident_fund_accounts_path)
        end
        it 'should assign @account' do
          get :update, id: @account.id, provident_fund_account: {rule_id: 1}
          expect(assigns(:account)).to eq(@account)
        end
      end
      context 'if @account not updated' do
        it 'should request to edit action of AccountsController' do
          get :update, id: @account.id, provident_fund_account: {rule_id: nil}
          expect(response).to render_template(:edit)
        end
      end
    end

    context 'if @account not present' do
      it 'should request to edit action of AccountsController' do
        get :update, id: 62, provident_fund_account: {rule_id: 1}
        expect(response).to redirect_to(provident_fund_accounts_path)
      end
    end

  end

  describe 'delete#destroy' do
    context 'if @account present' do
      it 'should request to destroy action of AccountsController' do
        delete :destroy, id: @account.id
        expect(response).to redirect_to(provident_fund_accounts_path)
      end
      it 'should request to destroy but failed to destroy' do
        delete :destroy, id: @account.id
        expect(response).to redirect_to(provident_fund_accounts_path)
      end
    end
    context 'if @account not present' do
      it 'should request to destroy action of AccountsController' do
        delete :destroy, id: 10
        expect(response).to redirect_to(provident_fund_accounts_path)
      end
    end
  end

  describe 'get#statement' do
    context 'if @pf_account present' do
      it 'should request to statement action of AccountsController' do
        get :statement, account_id: @account.id
        expect(response).to be_success
      end
      it 'should assign employee who has a providant fund account' do
        get :statement, account_id: @account.id
        expect(assigns(:pf_account)).to eq(@account)
      end
      it 'should assign employee who has a providant fund account' do
        get :statement, account_id: @account.id
        expect(assigns(:employee)).to eq(@employee)
      end
      it 'should response as pdf format' do
        xhr :get, :statement, format: :pdf, account_id: @account.id
        expect(response).to be_success
      end
      it 'should render to pdf template format' do
        xhr :get, :statement, format: :pdf, account_id: @account.id
        expect(response).to render_template('provident_fund/accounts/statement_pdf.html.erb')
      end
      it 'should response as docx format' do
        xhr :get, :statement, format: :docx, account_id: @account.id
        expect(response).to be_success
      end
      it 'should render to pdf template format' do
        xhr :get, :statement, format: :pdf, account_id: @account.id
        expect(response).to render_template('provident_fund/accounts/statement_pdf.html.erb')
      end
    end
    context 'if @pf_account not present' do
      it 'should redirect_to provident_fund_accounts_path ' do
        get :statement, account_id: 213
        expect(response).to redirect_to(provident_fund_accounts_path)
      end
    end
  end
  describe 'get#employee' do
    it 'should request to employee action of AccountsController' do
      xhr :get, :employee, format: :js, employee_id: @employee.id
      expect(response).to be_success
    end
    it 'should request to employee action of AccountsController' do
      xhr :get, :employee, format: :js, employee_id: @employee.id
      expect(assigns(:employee)).to eq(@employee)
    end
  end


end
