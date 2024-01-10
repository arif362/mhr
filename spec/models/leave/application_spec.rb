# == Schema Information
#
# Table name: leave_applications
#
#  id                :integer          not null, primary key
#  message           :text(65535)
#  note              :text(65535)
#  attachment        :string(255)
#  employee_id       :integer
#  leave_category_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  department_id     :integer
#  total_days        :integer
#  is_approved       :boolean          default(FALSE)
#  status            :string(255)      default("pending")
#  is_paid           :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe Leave::Application, type: :model do
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
  # describe 'Leave::Application #leave_report' do
  #   it "should return leave report" do
  #     start_date = Date.today
  #     end_date = Date.today + 7.day
  #     expect(Leave::Application.leave_report(@department, @employee, start_date, end_date)[:total_leave]).to eq(15)
  #     expect(Leave::Application.leave_report(@department, @employee, start_date, end_date)[:taken_leave]).to eq(4)
  #     expect(Leave::Application.leave_report(@department, @employee, start_date, end_date)[:paid_leave]).to eq(2)
  #     expect(Leave::Application.leave_report(@department, @employee, start_date, end_date)[:unpaid_leave]).to eq(2)
  #   end
  # end
end
