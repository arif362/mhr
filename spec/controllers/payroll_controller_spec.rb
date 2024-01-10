require 'rails_helper'

RSpec.describe PayrollController, type: :controller do

  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id:@company.id)
    @employee = FactoryGirl.create(:employee, role:Employee::ROLE[:admin], department_id:@department.id)
    session[:department_id] = @department.id
    sign_in(@employee)
  end

  describe 'get # dashboard' do
    it 'request to dashboard' do
      get :dashboard
      expect(response).to be_success
    end
  end

  describe 'get # summary' do
    it 'should request to summary' do
      xhr :get, :summary, format: :js, date: {year: Date.today.year}
      expect(response).to be_success
    end
  end

end
