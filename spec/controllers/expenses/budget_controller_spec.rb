require 'rails_helper'

RSpec.describe Expenses::BudgetsController, type: :controller do

  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id: @company.id)
    @employee = FactoryGirl.create(:employee, role: Employee::ROLE[:admin], department_id: @department.id)
    #@expenses_category = FactoryGirl.create(:expenses_category, department_id: @department.id)
    @budget = FactoryGirl.create(:budget, department_id: @department.id, company_id: @company.id)
    session[:department_id] = @department.id
    sign_in(@employee)
  end

  describe 'get#new' do
    it 'should request to new action of BudgetsController' do
      @expenses_category = FactoryGirl.create(:expenses_category, department_id: @department.id)
      get :new
      expect(response).to be_success
    end
    it 'should request to new action of BudgetsController' do
      get :new
      expect(response).to redirect_to(department_path(@department))
    end
  end

  # describe 'post#create' do
  #   it 'should request to create action of BudgetsController'
  #   post :create, amount:4565 , expenses_budget: {amount: 3000}
  #   expect(response).to redirect_to(budget_departments_path)
  # end

  describe 'get#edit' do
    it 'should request to edit action of BudgetsController' do
      xhr :get, :edit, format: :js, id: @budget.id
      expect(response).to be_success
    end
    it 'should request to edit action of BudgetsController' do
      xhr :get, :edit, format: :js, id: @budget.id
      expect(assigns(:budget)).to eq(@budget)
    end
  end

  describe 'put#update' do
    context ' when attributes updated' do
      it 'should request to update action of BudgetsController' do
        put :update, id: @budget.id, expenses_budget: {amount: 3000}
        expect(response).to redirect_to(budget_departments_path)
      end
    end
    context 'when attributes not updated' do
      it 'should request to update action of BudgetsController' do
        put :update, id: @budget.id, expenses_budget: {amount: nil}
        expect(response).to redirect_to(budget_departments_path)
      end
    end
  end

  # create and update_budget have to test

  describe 'get#get_budget' do
    it 'should request to get_budget action of BudgetController' do
      xhr :get, :get_budget, format: :js
      expect(response).to be_success
    end
  end

end
