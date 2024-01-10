# == Schema Information
#
# Table name: leave_days
#
#  id                   :integer          not null, primary key
#  day                  :date
#  leave_application_id :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  is_approved          :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe Leave::Day, type: :model do
  # before(:each) do
  #   @company = FactoryGirl.create(:company)
  #   @department =  FactoryGirl.create(:department, company_id: @company.id)
  #   @employee = FactoryGirl.create(:employee, department_id: @department.id)
  #   @leave_category = FactoryGirl.create(:leave_category, department_id: @department.id)
  #   @leave_application = FactoryGirl.create(:leave_application, department_id:@department.id, employee_id: @employee.id, leave_category_id: @leave_category.id, status: AppSettings::STATUS[:pending])
  #   @leave_application1 = FactoryGirl.create(:leave_application, department_id:@department.id, employee_id: @employee.id, leave_category_id: @leave_category.id, is_approved: true, status: AppSettings::STATUS[:approved], is_paid: true)
  #   @leave_application2 = FactoryGirl.create(:leave_application, department_id:@department.id, employee_id: @employee.id, leave_category_id: @leave_category.id, is_approved: true, status: AppSettings::STATUS[:approved], is_paid: false)
  #   @leave_day1 = FactoryGirl.create(:leave_days, day: Date.today, leave_application_id: @leave_application.id)
  #   @leave_day2 = FactoryGirl.create(:leave_days, day: Date.today, is_approved: true, leave_application_id: @leave_application1.id)
  #   @leave_day3 = FactoryGirl.create(:leave_days, day: Date.today + 1.day, is_approved: true, leave_application_id: @leave_application1.id)
  #   @leave_day4 = FactoryGirl.create(:leave_days, day: Date.today + 2.day, leave_application_id: @leave_application1.id)
  #   @leave_day5 = FactoryGirl.create(:leave_days, day: Date.today + 3.day, is_approved: true, leave_application_id: @leave_application2.id)
  #   @leave_day6 = FactoryGirl.create(:leave_days, day: Date.today + 4.day, is_approved: true, leave_application_id: @leave_application2.id)
  # end
  #
  # describe 'Leave::Day #approved_leave_days' do
  #   it "should return approved leave days with leave application" do
  #     start_date = Date.today
  #     end_date = Date.today + 7.day
  #     expect(Leave::Day.approved_leave_days(@department, @employee.id, start_date, end_date).count).to eq(4)
  #   end
  #
  #   it "should return approved leave days with leave application not all with short date range" do
  #     start_date = Date.today
  #     end_date = Date.today
  #     expect(Leave::Day.approved_leave_days(@department, @employee.id, start_date, end_date).count).to eq(1)
  #   end
  # end
  #
  # describe 'Leave::Day #approved_unpaid_leave_days' do
  #   it "should return approved unpaid leave days with leave application" do
  #     start_date = Date.today
  #     end_date = Date.today + 7.day
  #     expect(Leave::Day.approved_unpaid_leave_days(@department, @employee.id, start_date, end_date).count).to eq(2)
  #   end
  # end
end
