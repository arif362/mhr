# == Schema Information
#
# Table name: payroll_salaries
#
#  id                 :integer          not null, primary key
#  employee_id        :integer
#  department_id      :integer
#  payment_method     :string(255)
#  addition_category  :text(65535)
#  bonus              :float(24)
#  total              :float(24)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  deduction_category :text(65535)
#  month              :integer
#  year               :integer
#  basic_salary       :float(24)
#  total_addition     :float(24)
#  total_deduction    :float(24)
#  is_confirmed       :boolean          default(TRUE)
#  from_combined      :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe Payroll::Salary, type: :model do
  before(:each) do
    @month = Date.today.month
    @year = Date.today.year
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id: @company.id)
    @department.setting.update(open_time: '09:00:00', close_time: '18:00:00', working_hours: 8, time_zone: 'Dhaka', currency: 'bdt')
    @employee = FactoryGirl.create(:employee, department_id: @department.id, basic_salary: 30000)
    @employee2 = FactoryGirl.create(:employee, department_id: @department.id)
    @employee3 = FactoryGirl.create(:employee, department_id: @department.id)
    @employee4 = FactoryGirl.create(:employee, department_id: @department.id)
    @salary1 = FactoryGirl.create(:payroll_salary, employee_id: @employee.id, department_id: @department.id, is_confirmed: true)
    @salary2 = FactoryGirl.create(:payroll_salary, employee_id: @employee2.id, department_id: @department.id)
    @salary3 = FactoryGirl.create(:payroll_salary, employee_id: @employee3.id, department_id: @department.id)
    @payroll_category1 = FactoryGirl.create(:payroll_category, department_id: @department.id)
    @payroll_category2 = FactoryGirl.create(:payroll_category, department_id: @department.id, name: Faker::Lorem.word + '1', is_add: false)
    @payroll_category3 = FactoryGirl.create(:payroll_category, department_id: @department.id, name: Faker::Lorem.word + '2', is_percentage: false)
    @payroll_category4 = FactoryGirl.create(:payroll_category, department_id: @department.id, name: Faker::Lorem.word + '3', is_add: false, is_percentage: false)
    FactoryGirl.create(:payroll_employee_category, employee_id: @employee.id, category_id: @payroll_category1.id, percentage: 10, amount: nil)
    FactoryGirl.create(:payroll_employee_category, employee_id: @employee.id, category_id: @payroll_category2.id, percentage: 10, amount: nil)
    FactoryGirl.create(:payroll_employee_category, employee_id: @employee.id, category_id: @payroll_category3.id, percentage: nil, amount: 500)
    FactoryGirl.create(:payroll_employee_category, employee_id: @employee.id, category_id: @payroll_category4.id, percentage: nil, amount: 1000)

    #************************************************************************************************************************#
    month_start = Date.today.beginning_of_month

    #*******day Offs************#
    FactoryGirl.create(:attendance_day_off, date: month_start, day_off_type: AppSettings::DAYOFF_TYPES[:weekend], department_id: @department.id)
    FactoryGirl.create(:attendance_day_off, date: month_start + 1.day, day_off_type: AppSettings::DAYOFF_TYPES[:weekend], department_id: @department.id)
    FactoryGirl.create(:attendance_day_off, date: month_start + 2.day, department_id: @department.id)
    FactoryGirl.create(:attendance_day_off, date: month_start + 3.day, day_off_type: AppSettings::DAYOFF_TYPES[:custom_holiday], hours: 2, department_id: @department.id)
    FactoryGirl.create(:attendance_day_off, date: month_start + 4.day, day_off_type: AppSettings::DAYOFF_TYPES[:custom_holiday], hours: 3, department_id: @department.id)
    #*********day offs********#

    #********leave*************#
    leave_category = FactoryGirl.create(:leave_category, department_id: @department.id)
    leave_application = FactoryGirl.create(:leave_application, department_id: @department.id, employee_id: @employee.id, leave_category_id: leave_category.id, status: AppSettings::STATUS[:pending])
    leave_application1 = FactoryGirl.create(:leave_application, department_id:@department.id, employee_id: @employee.id, leave_category_id: leave_category.id, is_approved: true, status: AppSettings::STATUS[:approved], is_paid: true)
    leave_application2 = FactoryGirl.create(:leave_application, department_id:@department.id, employee_id: @employee.id, leave_category_id: leave_category.id, is_approved: true, status: AppSettings::STATUS[:approved], is_paid: false)
    FactoryGirl.create(:leave_days, day: month_start + 5, leave_application_id: leave_application.id)
    FactoryGirl.create(:leave_days, day: month_start + 5, is_approved: true, leave_application_id: leave_application1.id)
    FactoryGirl.create(:leave_days, day: month_start + 6.day, is_approved: true, leave_application_id: leave_application1.id)
    FactoryGirl.create(:leave_days, day: month_start + 7.day, leave_application_id: leave_application1.id)
    FactoryGirl.create(:leave_days, day: month_start + 8.day, is_approved: true, leave_application_id: leave_application2.id)
    FactoryGirl.create(:leave_days, day: month_start + 9.day, is_approved: true, leave_application_id: leave_application2.id)
    #********leave*************#

    #*********attendance**********#
    in_time_1 = DateTime.new(month_start.year, month_start.month, (month_start + 2.day).day, 9, 0, 0)
    out_time_1 = DateTime.new(month_start.year, month_start.month, (month_start + 2.day).day, 17, 0, 0)
    in_time_2 = DateTime.new(month_start.year, month_start.month, (month_start + 10.day).day, 9, 0, 0)
    out_time_2 = DateTime.new(month_start.year, month_start.month, (month_start + 10.day).day, 17, 0, 0)
    in_time_3 = DateTime.new(month_start.year, month_start.month, (month_start + 11.day).day, 10, 0, 0)
    out_time_3 = DateTime.new(month_start.year, month_start.month, (month_start + 11.day).day, 17, 0, 0)
    in_time_4 = DateTime.new(month_start.year, month_start.month, (month_start + 12.day).day, 9, 0, 0)
    out_time_4 = DateTime.new(month_start.year, month_start.month, (month_start + 12.day).day, 19, 0, 0)
    FactoryGirl.create(:attendance, in_date: month_start + 2.day, in_time: in_time_1, out_time: out_time_1, duration: 28800, employee_id: @employee.id, department_id: @department.id, employee: @employee)
    FactoryGirl.create(:attendance, in_date: month_start + 10.day, in_time: in_time_2, out_time: out_time_2, duration: 28800,employee_id: @employee.id, department_id: @department.id, employee: @employee)
    FactoryGirl.create(:attendance, in_date: month_start + 11.day, in_time: in_time_3, out_time: out_time_3, duration: 25200, employee_id: @employee.id, department_id: @department.id, employee: @employee)
    FactoryGirl.create(:attendance, in_date: month_start + 12.day, in_time: in_time_4, out_time: out_time_4, duration: 36000,employee_id: @employee.id, department_id: @department.id, employee: @employee)
    #*********attendance**********#
    #************************************************************************************************************#
  end

  describe 'class method#confirmed' do
    it 'should return confirmation' do
      expect(Payroll::Salary.confirmed(@month, @year)).to eq([@salary1])
    end
  end

  describe 'class method#unconfirmed' do
    context 'if month and year not present' do
      it 'should return is_confirmed false' do
        expect(Payroll::Salary.unconfirmed).to eq([@salary2, @salary3])
      end
    end
    context 'if month and year present' do
      it 'should return confirmation false' do
        expect(Payroll::Salary.unconfirmed(@month, @year)).to eq([@salary2, @salary3])
      end
    end
  end

  describe 'class method#process' do
    it 'should return employee new salary' do
      new_processed_salary = Payroll::Salary.process(@department, @employee, @month, @year)

      expect(new_processed_salary.month).to eq(Date.today.month)
      expect(new_processed_salary.year).to eq(Date.today.year)
      expect(new_processed_salary.basic_salary).to eq(@employee.basic_salary)
      expect(new_processed_salary.addition_category[:over_time]).to eq(10.0)
      expect(new_processed_salary.addition_category[("#{@payroll_category1.name}_amount").to_sym]).to eq(3000.0)
      expect(new_processed_salary.addition_category[("#{@payroll_category3.name}_amount").to_sym]).to eq(500.0)
      expect(new_processed_salary.deduction_category[("#{@payroll_category2.name}_deduct").to_sym]).to eq(3000.0)
      expect(new_processed_salary.deduction_category[("#{@payroll_category4.name}_deduct").to_sym]).to eq(1000.0)
      expect(new_processed_salary.deduction_category[:unpaid_leave_days]).to eq(2)
      expect(new_processed_salary.deduction_category[:late_days]).to eq(1)
      expect(new_processed_salary.deduction_category[:late_time]).to eq(1.0)
      expect(new_processed_salary.deduction_category[:less_worked_hours]).to eq(1.0)
    end
  end

  describe 'class method #get_employee_salary' do
    it 'should return newly processed salary' do
      employee_status = Employee.get_monthly_status(@department, @employee, @month, @year)
      payroll_categories = @employee.payroll_employee_categories.includes(:category)
      new_processed_salary = Payroll::Salary.get_employee_salary(@department, @employee, employee_status, payroll_categories, @month, @year)

      expect(new_processed_salary.month).to eq(Date.today.month)
      expect(new_processed_salary.year).to eq(Date.today.year)
      expect(new_processed_salary.basic_salary).to eq(@employee.basic_salary)
      expect(new_processed_salary.addition_category[:over_time]).to eq(10.0)
      expect(new_processed_salary.addition_category[("#{@payroll_category1.name}_amount").to_sym]).to eq(3000.0)
      expect(new_processed_salary.addition_category[("#{@payroll_category3.name}_amount").to_sym]).to eq(500.0)
      expect(new_processed_salary.deduction_category[("#{@payroll_category2.name}_deduct").to_sym]).to eq(3000.0)
      expect(new_processed_salary.deduction_category[("#{@payroll_category4.name}_deduct").to_sym]).to eq(1000.0)
      expect(new_processed_salary.deduction_category[:unpaid_leave_days]).to eq(2)
      expect(new_processed_salary.deduction_category[:late_days]).to eq(1)
      expect(new_processed_salary.deduction_category[:late_time]).to eq(1.0)
      expect(new_processed_salary.deduction_category[:less_worked_hours]).to eq(1.0)
    end
  end

  describe 'class method #percentage_amount' do
    it 'should return percentage of a given amount' do
      expect(Payroll::Salary.percentage_amount(salary=50000, percentage=10)).to eq(((salary.to_f * percentage.to_f) / 100.00).round(2))
    end
  end

  describe 'class method #amount_from_days' do
    it 'should return payable amount from given days' do
      expect(Payroll::Salary.amount_from_days(per_day_rate = 500, deduct_days = 5)).to eq((per_day_rate.to_f * deduct_days.to_f).round(2))
    end
  end

  describe 'class method #amount_from_hours' do
    it 'should return payable amount from per hour rate' do
      expect(Payroll::Salary.amount_from_hours(per_hour_rate = 100, hour=3)).to eq((per_hour_rate.to_f * hour.to_f).round(2))
    end
  end

  describe 'class method #hour_from_second' do
    it 'should return hour from given second value' do
      expect(Payroll::Salary.hour_from_second(second=3600)).to eq( (second.to_f / 3600.00).round(2))
    end
  end

  describe 'class method # get_payable_employees' do
    it 'should return payable_employees' do
      expect(Payroll::Salary.get_payable_employees(Employee.all, @month, @year)).to eq([@employee4])
    end
  end

  describe 'class method #dashboard_summary' do
    it 'should return gross salaries of 12 months' do
      expect(Payroll::Salary.dashboard_summary(@department, Date.today.year)[:gross_salaries][@month - 1]).to eq(60000)
      expect(Payroll::Salary.dashboard_summary(@department, Date.today.year)[:gross_salaries][@month == 1 ? 1 : 0]).to eq(0)
    end

    it 'should return deduct amounts of 12 months' do
      expect(Payroll::Salary.dashboard_summary(@department, Date.today.year)[:deduct_amounts][@month - 1]).to eq(10287)
      expect(Payroll::Salary.dashboard_summary(@department, Date.today.year)[:deduct_amounts][@month == 1 ? 1 : 0]).to eq(0)
    end

    it 'should return net salaries of 12 months' do
      expect(Payroll::Salary.dashboard_summary(@department, Date.today.year)[:net_salaries][@month - 1]).to eq(80013)
      expect(Payroll::Salary.dashboard_summary(@department, Date.today.year)[:net_salaries][@month == 1 ? 1 : 0]).to eq(0)
    end

    it 'should return total net salary of 12 months' do
      expect(Payroll::Salary.dashboard_summary(@department, Date.today.year)[:net_total]).to eq(80013)
    end
  end
end
