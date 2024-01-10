require 'rails_helper'

RSpec.describe ExpenseController, type: :controller do
  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id:@company.id)
    @employee = FactoryGirl.create(:employee, role: Employee::ROLE[:admin], department_id:@department.id)
    @expenses_category = FactoryGirl.create(:expenses_category, department_id: @department.id)
    @expenses_expense = FactoryGirl.create(:expenses_expense, department_id: @department.id, expense_category_id: @expenses_category.id, expense_sub_category_id: @expenses_category.id, created_by_id: @employee.id, approved_by_id: @employee.id)
    session[:department_id] = @department.id
    sign_in(@employee)
  end

  describe 'get#dashboard' do
    it 'should request to dashboard' do
      get :dashboard
      expect(response).to be_success
    end
  end

  describe 'get#summary' do
    it 'should request to summary' do
      xhr :get, :summary, format: :js
      expect(response).to be_success
    end
  end

  describe 'get#compare' do
    context 'When params not present' do
      it 'should request to compare' do
        xhr :get, :compare, format: :js
        expect(response).to be_success
      end
    end
    # context 'When params present' do
    #   it 'should request to compare with params' do
    #     xhr :get, :compare, format: :js, date:Date.today.beginning_of_month
    #     expect(response).to be_success
    #   end
    # end
  end

  describe 'get#yearly' do
    it 'should request to yearly' do
      xhr :get, :yearly, format: :js
      expect(response).to be_success
    end
  end

end
