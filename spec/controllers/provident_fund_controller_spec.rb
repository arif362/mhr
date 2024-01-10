require 'rails_helper'

RSpec.describe ProvidentFundController, type: :controller do

  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id:@company.id)
    @employee = FactoryGirl.create(:employee, role:Employee::ROLE[:admin], department_id:@department.id)
    session[:department_id] = @department.id
    sign_in(@employee)
  end

  describe 'get#dashboard' do
    it 'should request to dashboard' do
      get :dashboard
      expect(response).to be_success
    end
  end

  describe 'get#statement' do
    it 'should request to statement' do
      get :statement, daterange: Date.today.beginning_of_month - Date.today.month
      expect(response).to be_success
    end
  end

end
