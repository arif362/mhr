require 'rails_helper'

RSpec.describe Employees::ConfirmationsController, type: :controller do

  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id:@company.id)
    @employee = FactoryGirl.create(:employee, role:Employee::ROLE[:admin], department_id:@department.id)
    session[:department_id] = @department.id
    sign_in(@employee)
  end

  # describe 'get # new' do
  #   it 'should request to new action' do
  #     get :new
  #     expect(response).to be_success
  #   end
  # end

end