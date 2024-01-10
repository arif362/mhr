# == Schema Information
#
# Table name: attendance_attendances
#
#  id            :integer          not null, primary key
#  in_date       :date
#  in_time       :datetime
#  out_time      :datetime
#  duration      :float(24)
#  employee_id   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  department_id :integer
#

require 'rails_helper'

RSpec.describe Attendance::Attendance, type: :model do
  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id: @company.id)
    #@department_2 =  FactoryGirl.create(:department, company_id: @company.id)
    @employee = FactoryGirl.create(:employee, role: Employee::ROLE[:admin], department_id: @department.id)
    @department_setting = @department.setting.update(open_time: "09:00:00", close_time: "18:00:00", working_hours: 8, time_zone: 'Dhaka')
    #@department_setting_2 = @department.setting.update(open_time: nil, close_time: nil, working_hours: nil)
    @attendance_1 = FactoryGirl.create(:attendance, employee_id: @employee.id, department_id: @department.id, employee: @employee)
    in_time_1 = DateTime.new(Date.today.year, Date.today.month, Date.today.day, 13, 0, 0)
    out_time_1 = DateTime.new(Date.today.year, Date.today.month, Date.today.day, 18, 0, 0)
    in_time_2 = DateTime.new((Date.today - 1.day).year, (Date.today - 1.day).month, (Date.today - 1.day).day, 10, 0, 0) #late in
    out_time_2 = DateTime.new((Date.today - 1.day).year, (Date.today - 1.day).month, (Date.today - 1.day).day, 16, 0, 0) #less work out
    in_time_3 = DateTime.new((Date.today - 2.day).year, (Date.today - 2.day).month, (Date.today - 2.day).day, 9, 0, 0)
    out_time_3 = DateTime.new((Date.today - 2.day).year, (Date.today - 2.day).month, (Date.today - 2.day).day, 19, 0, 0)
    @attendance_2 = FactoryGirl.create(:attendance, in_time: in_time_1, out_time: out_time_1, duration: 18000, employee_id: @employee.id, department_id: @department.id, employee: @employee) #.today.to_s + " 09:00:00" ,,," 10:00:00"
    @attendance_3 = FactoryGirl.create(:attendance, in_date: Date.today - 1.day, in_time: in_time_2, out_time: out_time_2, duration: 21600, employee_id: @employee.id, department_id: @department.id, employee: @employee)
    @attendance_4 = FactoryGirl.create(:attendance, in_date: Date.today - 2.day, in_time: in_time_3, out_time: out_time_3, duration: 36000, employee_id: @employee.id, department_id: @department.id, employee: @employee)
  end

  describe 'Attendance::Attendance #attendance_report' do
    it 'should return attendance report' do
      start_date = Date.today - 7.day
      end_date = Date.today + 1.day
      expect(Attendance::Attendance.attendance_report(@department, @employee, start_date, end_date)[:late_time]).to eq(3600)
      expect(Attendance::Attendance.attendance_report(@department, @employee, start_date, end_date)[:over_time]).to eq(7200)
      expect(Attendance::Attendance.attendance_report(@department, @employee, start_date, end_date)[:worked_hour]).to eq(86400)
      expect(Attendance::Attendance.attendance_report(@department, @employee, start_date, end_date)[:extra_present_days]).to eq(0)
      expect(Attendance::Attendance.attendance_report(@department, @employee, start_date, end_date)[:present_days]).to eq(3)
      expect(Attendance::Attendance.attendance_report(@department, @employee, start_date, end_date)[:less_worked_hour]).to eq(7200)
    end
  end

  describe 'Attendance::Attendance #get_late_time' do
    it 'should return late time where no late actually' do
      expect(Attendance::Attendance.get_late_time(Date.today, @department.setting.open_time, @attendance_1.in_time)).to eq(0)
    end

    it 'should return late time' do
      expect(Attendance::Attendance.get_late_time(Date.today - 1.day, @department.setting.open_time, @attendance_3.in_time)).to eq(3600)
    end
  end
end
