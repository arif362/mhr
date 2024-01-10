require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  # before(:each) do
  #   @company = FactoryGirl.create(:company)
  #   @feature = FactoryGirl.create(:feature, name: 'Attendance')
  #   @company_feature = FactoryGirl.create(:company_feature, company_id: @company.id, feature_id: @feature.id )
  #   @department = FactoryGirl.create(:department, company_id: @company.id)
  #   @department_2 = FactoryGirl.create(:department, name: 'Mirpur Branch', company_id: @company.id)
  #   @department_3 = FactoryGirl.create(:department, name: 'Pallabi Branch', company_id: @company.id)
  #   @department_setting = @department.setting.update(open_time: "09:00:00", close_time: "18:00:00", working_hours: 8, currency: 'all')
  #   @department_setting_2 = @department_2.setting.update(open_time: "09:00:00", close_time: "18:00:00", working_hours: nil)
  #   @employee = FactoryGirl.create(:employee, department_id: @department.id)
  #   @employee_with_next_path = FactoryGirl.create(:employee, department_id: @department.id, next_path: '/setting')
  #   @employee_staff = FactoryGirl.create(:employee, department_id: @department.id, role: 'staff')
  #   @employee_not_active = FactoryGirl.create(:employee, department_id: @department.id, role: 'staff', is_active: false, deactivate_date: (Date.today - 1.day))
  #   @access_right_admin = FactoryGirl.create(:access_right, employee_id: @employee.id)
  #   @access_right_admin_1 = FactoryGirl.create(:access_right, employee_id: @employee_with_next_path.id)
  #   @access_right_admin_3 = FactoryGirl.create(:access_right, employee_id: @employee_staff.id)
  #   @attendance = FactoryGirl.create(:attendance, employee_id: @employee.id, department_id: @department.id)
  #   session[:department_id] = @department.id
  #   sign_in(@employee)
  # end
  # describe 'ApplicationController' do
  #   it 'Should request to ApplicationController after_sign_in_path_for' do
  #     expect(controller.after_sign_in_path_for(@employee)).to eq(root_path)
  #   end
  #   it 'Should request to ApplicationController after_sign_in_path_for with next path' do
  #     expect(controller.after_sign_in_path_for(@employee_with_next_path)).to eq('/setting')
  #   end
  #   it 'Should request to ApplicationController after_sign_in_path_for as staff' do
  #     expect(controller.after_sign_in_path_for(@employee_staff)).to eq(employee_path(@employee_staff))
  #   end
  #
  #   it 'Should request to ApplicationController employee_role with resource' do
  #     application_obj = ApplicationController.new
  #     expect(application_obj.employee_role(@employee)).to eq('admin')
  #   end
  #
  #   it 'Should request to ApplicationController employee_role without resource' do
  #     expect(controller.employee_role).to eq('admin')
  #   end
  #   it 'Should request to ApplicationController employee_role with resource and staff' do
  #     expect(controller.employee_role(@employee_staff)).to eq('staff')
  #   end
  #
  #   it 'Should request to ApplicationController current_department' do
  #     session[:department_id] = @department.id
  #     expect(controller.current_department).to eq(@department)
  #   end
  #
  #   it 'Should request to ApplicationController current_department from first entry' do
  #     session[:department_id] = 300
  #     expect(controller.current_department).to eq(@department)
  #   end
  #
  #   it 'Should request to ApplicationController current_department when session not present' do
  #     session[:department_id] = nil
  #     expect(controller.current_department).to eq(@employee.department)
  #   end
  #
  #   it 'Should request to ApplicationController formate_string_date' do
  #     expect(ApplicationController.new.formate_string_date('07-10-2016')).to eq('2016-10-07')
  #   end
  #
  #   it 'Should request to ApplicationController todays_attendances' do
  #     expect(ApplicationController.new.todays_attendances(@employee)).to eq([@attendance])
  #   end
  # end
  #
  # describe '#current_active_emloyees' do
  #   it "should return all active employee's of current department" do
  #     expect(controller.current_active_emloyees).to eq(@department.employees.where('invitation_token IS NULL and is_active = true'))
  #   end
  # end
  #
  # describe '#current_currency' do
  #   context 'if department setting and currency are set' do
  #     it "should return department's currency" do
  #       expect(controller.current_currency).to eq('ALL')
  #     end
  #   end
  #   context 'if department has setting but currency not set' do
  #     it 'should return bdt as currency' do
  #       session[:department_id] = @department_2.id
  #       expect(controller.current_currency).to eq('BDT')
  #     end
  #   end
  #   context 'if departement has no setting' do
  #     it 'should return bdt as currency' do
  #       session[:department_id] = @department_3.id
  #       expect(controller.current_currency).to eq('BDT')
  #     end
  #   end
  # end
  #
  # describe '#permit_module' do
  #   context 'if company has the module' do
  #     it 'should return company of current department' do
  #       expect(controller.permit_module('Attendance')).to eq(nil)
  #     end
  #   end
  # end
  #
  # describe '#flash_types' do
  #   it 'should return flash message types' do
  #     expect(controller.flash_types.length).to eq(4)
  #   end
  # end
  #
  # describe '#current_department_active_employees' do
  #   it 'should return active employees of department whose deacvate date is before a passing date' do
  #     expect(controller.current_department_active_employees(Date.today)).to eq([@employee, @employee_with_next_path, @employee_staff])
  #   end
  # end
  #
  # describe '#resource_name' do
  #   it 'should return name of the resource' do
  #     expect(controller.resource_name).to eq(:employee)
  #   end
  # end
  #
  # describe '#resource' do
  #   it 'should return resource' do
  #     expect(controller.resource).to be_a_new(Employee)
  #   end
  # end
end
