require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do
  # before(:each) do
  #   @company = FactoryGirl.create(:company)
  #   @department = FactoryGirl.create(:department, company_id: @company.id)
  #   @employee_one = FactoryGirl.create(:employee, department_id: @department.id)
  #   @employee_two = FactoryGirl.create(:employee, department_id: @department.id)
  #   @attendance_with_outtime = FactoryGirl.create(:attendance, employee_id: @employee_one.id, department_id: @department.id)
  #   @attendance_without_outtime = FactoryGirl.create(:attendance, in_time: Date.today.to_s + " 09:00:00", out_time: nil, duration: nil, employee_id: @employee_one.id, department_id: @department.id)
  #   sign_in(@employee_one)
  # end
  #
  # describe 'ApplicationHelper' do
  #   it 'should request to ApplicationHelper inline_validation' do
  #     new_company = Company.new
  #     new_company.mobile = Faker::PhoneNumber.phone_number
  #     new_company.address = Faker::Address.secondary_address
  #     new_company.validate
  #     expect(inline_validation(new_company, 'name')).to eq('<span class=\'validation-error\' style=\'color:red\'> can\'t be blank </span>')
  #   end
  #
  #   # it 'should request to ApplicationHelper in_out_button_select current employee equal employee with attendances without out time' do
  #   #   out_button_html = '<a id="employee_attendances" class="btn btn-danger" data-remote="true" rel="nofollow" data-method="put" href="/attendance/attendances/' + @attendance_without_outtime.id.to_s + '">Out</a>'
  #   #   expect(in_out_button_select([@attendance_without_outtime], @employee_one, @employee_one)).to eq(out_button_html)
  #   # end
  #   #
  #   # it 'should request to ApplicationHelper in_out_button_select current employee equal employee with attendances and out time' do
  #   #   in_button_html = '<a id="employee_attendances" class="btn btn-success" data-remote="true" rel="nofollow" data-method="post" href="/attendance/attendances">In</a>'
  #   #   expect(in_out_button_select([@attendance_with_outtime], @employee_one, @employee_one)).to eq(in_button_html)
  #   # end
  #   #
  #
  #   it 'should request to ApplicationHelper formate_date with date' do
  #     expect(formate_date(Date.parse('2016-10-10'))).to eq('10 October, 2016')
  #   end
  #
  #   it 'should request to ApplicationHelper formate_date without date' do
  #     expect(formate_date(nil)).to eq(nil)
  #   end
  #
  #   it 'should request to ApplicationHelper get_time_from_datetime with datetime' do
  #     expect(get_time_from_datetime(DateTime.parse('2016-10-10 10:10:10'))).to eq('10:10:10 AM')
  #   end
  #
  #   it 'should request to ApplicationHelper get_time_from_datetime without datetime' do
  #     expect(get_time_from_datetime(nil)).to eq(nil)
  #   end
  #
  #   it 'should request to ApplicationHelper formate_duration with duration less than or equal 0' do
  #     expect(formate_duration(0)).to eq(' ')
  #   end
  #
  #   it 'should request to ApplicationHelper formate_duration with duration greater than 0 less than 60' do
  #     expect(formate_duration(40)).to eq('40.0  Sec')
  #   end
  #
  #   it 'should request to ApplicationHelper formate_duration with duration greater than 60 less than 3600' do
  #     expect(formate_duration(80)).to eq('1.33  Min')
  #   end
  #
  #   it 'should request to ApplicationHelper formate_duration with duration greater than 3600' do
  #     expect(formate_duration(6000)).to eq('1.67  Hour')
  #   end
  #
  #   it 'should request to ApplicationHelper formate_duration without duration' do
  #     expect(formate_duration(nil)).to eq(nil)
  #   end
  #
  #   # TODO : application helper test departments not yet done
  #   # it 'should request to ApplicationHelper departments' do
  #   #   session[:department_id] = @department.id
  #   #   expect(helper.departments).to eq([@department])
  #   # end
  # end
end
