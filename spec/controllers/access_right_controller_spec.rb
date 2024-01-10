# require 'rails_helper'
# require 'faker'
#
# RSpec.describe AccessRightsController, type: :controller do
#
#   before(:each) do
#     @company = FactoryGirl.create(:company)
#     @department = FactoryGirl.create(:department, company_id:@company.id)
#     @employee = FactoryGirl.create(:employee, role:Employee::ROLE[:admin], department_id:@department.id)
#     @access_right = FactoryGirl.create(:access_right, employee_id:@employee.id)
#     session[:department_id] = @department.id
#     sign_in(@employee)
#   end
#
#   describe 'put#update' do
#     it 'should request to update action' do
#       put :update, id:@access_right.id, access_right:  {permissions: { 'access_right'=> '3','department'=> '3','designation'=> '3','employee'=> '3','leave_application'=> '3','setting'=> '3','leave_category'=> '3','attendance'=> '3','day_off'=> '3'}}
#       expect(response).to be_success
#     end
#   end
#
#
# end