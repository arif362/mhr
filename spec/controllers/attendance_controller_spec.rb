require 'rails_helper'
RSpec.describe AttendanceController, type: :controller do

  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id:@company.id)
    @employee = FactoryGirl.create(:employee, role: Employee::ROLE[:admin], department_id:@department.id)
    @attendance = FactoryGirl.create(:attendance, employee_id:@employee.id, department_id:@department.id)
    session[:department_id] = @department.id
    sign_in(@employee)
  end

  describe 'get #dashboard' do
    it 'should request to dashboard' do
      get :dashboard
      expect(response).to be_success
      expect(assigns(:attendances)).to eq([@attendance])
    end
  end

end