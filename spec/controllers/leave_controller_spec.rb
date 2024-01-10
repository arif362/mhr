require 'rails_helper'

RSpec.describe LeaveController, type: :controller do
  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id: @company.id)
    @employee = FactoryGirl.create(:employee, role:Employee::ROLE[:admin], department_id: @department.id)
    @leave_category = FactoryGirl.create(:leave_category,department_id: @department.id)
    @leave_application_1 = FactoryGirl.create(:leave_application, department_id:@department.id, employee_id: @employee.id, leave_category_id: @leave_category.id, is_approved: false, status: AppSettings::STATUS[:pending])
    @leave_day_1 = FactoryGirl.create(:leave_days, day: Date.today - 1.day, is_approved: true, leave_application_id: @leave_application_1.id)
    session[:department_id] = @department.id
    sign_in(@employee)
  end

  describe 'get # dashboard' do
    it 'should request to LeaveController dashboard' do
      get :dashboard
      expect(response).to be_success
    end
  end

end
