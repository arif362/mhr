# == Schema Information
#
# Table name: attendance_day_offs
#
#  id            :integer          not null, primary key
#  year          :integer
#  date          :date
#  day_off_type  :string(255)
#  hours         :float(24)
#  title         :string(255)
#  department_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Attendance::DayOff, type: :model do
  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id: @company.id)
    @employee = FactoryGirl.create(:employee, department_id: @department.id)
    @day_off_1 = FactoryGirl.create(:attendance_day_off, day_off_type: AppSettings::DAYOFF_TYPES[:weekend], department_id: @department.id)
    @day_off_2 = FactoryGirl.create(:attendance_day_off, date: Date.today + 1.day, day_off_type: AppSettings::DAYOFF_TYPES[:weekend], department_id: @department.id)
    @day_off_3 = FactoryGirl.create(:attendance_day_off, date: Date.today + 2.day, department_id: @department.id)
    @day_off_4 = FactoryGirl.create(:attendance_day_off, date: Date.today + 3.day, day_off_type: AppSettings::DAYOFF_TYPES[:custom_holiday], hours: 2, department_id: @department.id)
    @day_off_5 = FactoryGirl.create(:attendance_day_off, date: Date.today + 4.day, day_off_type: AppSettings::DAYOFF_TYPES[:custom_holiday], hours: 3, department_id: @department.id)
    #session[:department_id] = @department.id
    #sign_in(@employee)
  end

  describe 'DayOff #set_day_off_year' do
    it "should save year on day off create" do
      expect(Attendance::DayOff.all.first.year).to eq(Date.today.year)
    end
    it "should save year on day off create" do
      expect(@day_off_1.set_day_off_year.to_i).to eq(Date.today.year)
    end
  end

  describe 'DayOff #day_off_report' do
    it "should return day off report" do
      start_date = Date.today - 1.day
      end_date = Date.today + 10.day
      expect(Attendance::DayOff.day_off_report(@department, start_date, end_date)[:weekend_days]).to eq(2)
      expect(Attendance::DayOff.day_off_report(@department, start_date, end_date)[:holidays]).to eq(1)
      expect(Attendance::DayOff.day_off_report(@department, start_date, end_date)[:custom_holiday_hours]).to eq(18000)
    end

    it "should return day off report partial only weekends" do
      start_date = Date.today
      end_date = Date.today + 1.day
      expect(Attendance::DayOff.day_off_report(@department, start_date, end_date)[:weekend_days]).to eq(2)
      expect(Attendance::DayOff.day_off_report(@department, start_date, end_date)[:holidays]).to eq(0)
      expect(Attendance::DayOff.day_off_report(@department, start_date, end_date)[:custom_holiday_hours]).to eq(0)
    end
  end
end
