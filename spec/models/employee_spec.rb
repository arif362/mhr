# == Schema Information
#
# Table name: employees
#
#  id                          :integer          not null, primary key
#  email                       :string(255)      default(""), not null
#  encrypted_password          :string(255)      default("")
#  reset_password_token        :string(255)
#  reset_password_sent_at      :datetime
#  remember_created_at         :datetime
#  sign_in_count               :integer          default(0), not null
#  current_sign_in_at          :datetime
#  last_sign_in_at             :datetime
#  current_sign_in_ip          :string(255)
#  last_sign_in_ip             :string(255)
#  confirmation_token          :string(255)
#  confirmed_at                :datetime
#  confirmation_sent_at        :datetime
#  unconfirmed_email           :string(255)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  first_name                  :string(255)
#  last_name                   :string(255)
#  note                        :text(65535)
#  location                    :string(255)
#  dob                         :date
#  address                     :text(65535)
#  gender                      :string(255)
#  image                       :string(255)
#  department_id               :integer
#  role                        :string(255)      default("staff")
#  invitation_token            :string(255)
#  invitation_created_at       :datetime
#  invitation_sent_at          :datetime
#  invitation_accepted_at      :datetime
#  invitation_limit            :integer
#  invited_by_id               :integer
#  invited_by_type             :string(255)
#  blood_group                 :string(255)
#  joining_date                :date
#  designation_id              :integer
#  basic_salary                :float(24)
#  mobile                      :string(255)
#  nid                         :string(255)
#  kin_name                    :string(255)
#  kin_contact                 :string(255)
#  is_active                   :boolean          default(TRUE)
#  deactivated_by              :integer
#  deactivate_date             :date
#  id_card_no                  :string(255)
#  employee_type               :string(255)
#  present_address             :string(255)
#  permanent_address           :string(255)
#  color                       :string(255)
#  slug                        :string(255)
#  kin_relationship            :string(255)
#  marital_status              :string(255)
#  nationality                 :string(255)
#  country                     :string(255)
#  attachment                  :string(255)
#  bank_account_number         :string(255)
#  bank_details                :text(65535)
#  previous_employment_history :string(255)
#  religion                    :string(255)
#

require 'rails_helper'

RSpec.describe Employee, type: :model do
  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id: @company.id)
    @designation = FactoryGirl.create(:designation, department_id:@department.id)
    @employee = FactoryGirl.create(:employee, role: Employee::ROLE[:admin], department_id: @department.id, designation: @designation)
    @employee_1 = FactoryGirl.create(:employee, role: Employee::ROLE[:admin], first_name:'abc', department_id: @department.id, designation: @designation)
    #   @employee.update_attributes(color: "#98d57c")
    @employee_without_last_name = FactoryGirl.create(:employee, basic_salary: 20000.00, department_id: @department.id, present_address: nil,designation: @designation)
    @employee_without_first_name = FactoryGirl.create(:employee, present_address: nil, permanent_address: nil,designation: @designation)
    @employee_full_name = FactoryGirl.create(:employee, department_id: @department.id, designation: @designation)
    @employee_without_address = FactoryGirl.create(:employee, location: nil, present_address: nil, permanent_address: nil,designation: @designation)
    @department_setting = @department.setting.update(open_time: "09:00:00", close_time: "18:00:00", working_hours: 8)
    # @department_setting_2 = @department_2.setting.update(open_time: "09:00:00", close_time: "18:00:00", working_hours: nil)
    last_month_start = (Date.today.beginning_of_month - 1.day).beginning_of_month
    @day_off_1 = FactoryGirl.create(:attendance_day_off, date: last_month_start, day_off_type: AppSettings::DAYOFF_TYPES[:weekend], department_id: @department.id)
    @day_off_2 = FactoryGirl.create(:attendance_day_off, date: last_month_start + 1.day, day_off_type: AppSettings::DAYOFF_TYPES[:weekend], department_id: @department.id)
    @day_off_3 = FactoryGirl.create(:attendance_day_off, date: last_month_start + 2.day, department_id: @department.id)
    @day_off_4 = FactoryGirl.create(:attendance_day_off, date: last_month_start + 3.day, day_off_type: AppSettings::DAYOFF_TYPES[:custom_holiday], hours: 2, department_id: @department.id)
    @day_off_5 = FactoryGirl.create(:attendance_day_off, date: last_month_start + 4.day, day_off_type: AppSettings::DAYOFF_TYPES[:custom_holiday], hours: 3, department_id: @department.id)
    @leave_category = FactoryGirl.create(:leave_category, department_id: @department.id)
    @leave_application = FactoryGirl.create(:leave_application, department_id: @department.id, employee_id: @employee.id, leave_category_id: @leave_category.id, status: AppSettings::STATUS[:pending])
    @leave_application1 = FactoryGirl.create(:leave_application, department_id:@department.id, employee_id: @employee.id, leave_category_id: @leave_category.id, is_approved: true, status: AppSettings::STATUS[:approved], is_paid: true)
    @leave_application2 = FactoryGirl.create(:leave_application, department_id:@department.id, employee_id: @employee.id, leave_category_id: @leave_category.id, is_approved: true, status: AppSettings::STATUS[:approved], is_paid: false)
    @leave_day1 = FactoryGirl.create(:leave_days, day: last_month_start + 5, leave_application_id: @leave_application.id)
    @leave_day2 = FactoryGirl.create(:leave_days, day: last_month_start + 5, is_approved: true, leave_application_id: @leave_application1.id)
    @leave_day3 = FactoryGirl.create(:leave_days, day: last_month_start + 6.day, is_approved: true, leave_application_id: @leave_application1.id)
    @leave_day4 = FactoryGirl.create(:leave_days, day: last_month_start + 7.day, leave_application_id: @leave_application1.id)
    @leave_day5 = FactoryGirl.create(:leave_days, day: last_month_start + 8.day, is_approved: true, leave_application_id: @leave_application2.id)
    @leave_day6 = FactoryGirl.create(:leave_days, day: last_month_start + 9.day, is_approved: true, leave_application_id: @leave_application2.id)
    in_time_1 = DateTime.new(last_month_start.year, last_month_start.month, (last_month_start + 2.day).day, 9, 0, 0)
    out_time_1 = DateTime.new(last_month_start.year, last_month_start.month, (last_month_start + 2.day).day, 17, 0, 0)
    in_time_2 = DateTime.new(last_month_start.year, last_month_start.month, (last_month_start + 10.day).day, 9, 0, 0)
    out_time_2 = DateTime.new(last_month_start.year, last_month_start.month, (last_month_start + 10.day).day, 17, 0, 0)
    in_time_3 = DateTime.new(last_month_start.year, last_month_start.month, (last_month_start + 11.day).day, 10, 0, 0)
    out_time_3 = DateTime.new(last_month_start.year, last_month_start.month, (last_month_start + 11.day).day, 17, 0, 0)
    in_time_4 = DateTime.new(last_month_start.year, last_month_start.month, (last_month_start + 12.day).day, 9, 0, 0)
    out_time_4 = DateTime.new(last_month_start.year, last_month_start.month, (last_month_start + 12.day).day, 19, 0, 0)
    @attendance_1 = FactoryGirl.create(:attendance, in_date: last_month_start + 2.day, in_time: in_time_1, out_time: out_time_1, duration: 28800, employee_id: @employee.id, department_id: @department.id, employee: @employee)
    @attendance_2 = FactoryGirl.create(:attendance, in_date: last_month_start + 10.day, in_time: in_time_2, out_time: out_time_2, duration: 28800,employee_id: @employee.id, department_id: @department.id, employee: @employee)
    @attendance_3 = FactoryGirl.create(:attendance, in_date: last_month_start + 11.day, in_time: in_time_3, out_time: out_time_3, duration: 25200, employee_id: @employee.id, department_id: @department.id, employee: @employee)
    @attendance_4 = FactoryGirl.create(:attendance, in_date: last_month_start + 12.day, in_time: in_time_4, out_time: out_time_4, duration: 36000,employee_id: @employee.id, department_id: @department.id, employee: @employee)
  end

  describe 'instance method #full_name' do
    it 'Should return full name as first_name + last_name' do
      expect(@employee.full_name).to eq(@employee.first_name + ' ' + @employee.last_name)
    end
  end

  describe 'instance method #full_address' do
    context 'when present address is present' do
      it 'should return present address as full address' do
        expect(@employee.full_address).to eq(@employee.present_address)
      end
    end
    context 'when present address not present but permanent address is present' do
      it 'should return permanent address as full address' do
        expect(@employee_without_last_name.full_address).to eq(@employee_without_last_name.permanent_address)
      end
    end
    context 'when present and permanent address not present but location is present' do
      it 'should return location as full address' do
        expect(@employee_without_first_name.full_address).to eq(@employee_without_first_name.location)
      end
    end
    context 'when all of these addresses field are empty' do
      it 'should return null as full address' do
        expect(@employee_without_address.full_address).to eq('')
      end
    end
  end

  describe 'instance method #get_basic_salary' do
    context 'when basic salary not set' do
      it "should return employee's basic salary" do
        expect(@employee.get_basic_salary).to eq(0.00)
      end
    end
    context 'when basic salary already set' do
      it "should return employee's basic salary" do
        expect(@employee_without_last_name.get_basic_salary).to eq(20000.00)
      end
    end
  end

  describe 'instance method #change_employee_salary' do
    context 'if self.basic_salary present' do
      it 'should return incremented salary of employee' do
        payroll_increment = FactoryGirl.create(:payroll_increment, employee_id: @employee.id, department_id: @department.id)
        expect(@employee_without_last_name.change_employee_salary(payroll_increment)).to eq(true)
      end
    end
    context 'if self.basic_salary not present' do
      it 'should return incremented salary of employee' do
        payroll_increment = FactoryGirl.create(:payroll_increment, employee_id: @employee.id, department_id: @department.id)
        expect(@employee.change_employee_salary(payroll_increment)).to eq(true)
      end
    end
  end

  describe 'instance method#assign_color_code' do
    it 'should return color of employee' do
      expect(@employee.assign_color_code).to eq(@employee.color)
    end
  end

  describe 'instance method #super_admin?' do
    context 'when employee role is admin' do
      it 'should return true' do
        expect(@employee.super_admin?).to eq(true)
      end
    end
    context 'when employee role is staff' do
      it 'should return false' do
        expect(@employee_without_last_name.super_admin?).to eq(false)
      end
    end
  end

  describe 'class method #prepare_company' do
    context ' if company_params present' do
      it 'Should save company, department and employee on company registration' do
        count = Company.count
        count = Department.count
        company_params = {name: Faker::Company.name, mobile: Faker::PhoneNumber.phone_number, address: Faker::Address.secondary_address, zip_code: 1234, country: 'Bangladesh'}
        expect(Employee.prepare_company(@employee, company_params)).to eq(true)
        expect(Company.count).to eq(count+1)
        expect(Department.count).to eq(count+1)
      end
    end

    context 'if company_params not present' do
      it ' should return nil ' do
        company_params = {}
        expect(Employee.prepare_company(@employee, company_params)).to eq(nil)
      end
    end
  end


  describe 'class method #get_monthly_status' do
    start_date = (Date.today.beginning_of_month - 1.day).beginning_of_month
    office_days = Time.days_in_month(start_date.month, start_date.year) - 3
    absent_days = office_days - (3 + 4) # (present_days + taken_leave)
    it "should return employee's number of weekend days" do
      expect(Employee.get_monthly_status(@department, @employee, start_date.month, start_date.year)[:dayoffs_report][:weekend_days]).to eq(2)
    end
    it 'should return number of holidays' do
      expect(Employee.get_monthly_status(@department, @employee, start_date.month, start_date.year)[:dayoffs_report][:holidays]).to eq(1)
    end
    it 'should return total custom holidays in second' do
      expect(Employee.get_monthly_status(@department, @employee, start_date.month, start_date.year)[:dayoffs_report][:custom_holiday_hours]).to eq(18000)
    end
    it 'should return number of paid leave days' do
      expect(Employee.get_monthly_status(@department, @employee, start_date.month, start_date.year)[:leaves_report][:paid_leave]).to eq(2)
    end
    it 'should return second which is an employee should worked in a month' do
      expect(Employee.get_monthly_status(@department, @employee, start_date.month, start_date.year)[:should_worked]).to eq(702000)
    end
    it 'should return number of office days in a month' do
      expect(Employee.get_monthly_status(@department, @employee, start_date.month, start_date.year)[:office_days]).to eq(office_days)
    end
    it 'should return number of absent days in a month' do
      expect(Employee.get_monthly_status(@department, @employee, start_date.month, start_date.year)[:absent_days]).to eq(absent_days)
    end
  end

  describe 'class method# search' do
    context 'if params[:q] present' do
      it 'should return all employees like params' do
        expect(Employee.search(@department, {q:'abc'})).to eq(Employee.includes(:designation).where(id: @employee_1.id))
       # expect(Employee.search(@department, {q:'abc'})).to eq([@employee_1])
      end
    end
    context 'if params[:q] not present' do
      it 'should return all employees like params' do
        expect(Employee.search(@department, {q:nil})).to eq(@department.employees.includes(:designation).where('invitation_token IS NULL'))
      end
    end
  end

  describe 'class method#employee_should_worked' do
    it 'should return working time' do
      start_date = Date.new(Date.today.year, Date.today.month, 1)
      end_date = start_date.end_of_month
      dayoffs_report = Attendance::DayOff.day_off_report(@department, start_date, end_date)
      leaves_report = Leave::Application.leave_report(@department, @employee, start_date, end_date)
      month_days = (end_date-start_date).to_i+1
      dept_working_hour = @department.setting.working_hours
      expect(Employee.employee_should_worked(@department, dayoffs_report, leaves_report, start_date, end_date)).to eq(892800)
    end
  end

  describe 'class method #number_of_days' do
    it 'should return difference of two days' do
      start_date = Date.today.beginning_of_month
      end_date = start_date.end_of_month
      difference = (end_date - start_date) +1
      expect(Employee.number_of_days(start_date, end_date)).to eq(difference)
    end
  end

  describe 'instance method #amount_from_percentage' do
    context 'if basic salary not set' do
      it 'should return 0 as amount' do
        expect(@employee.amount_from_percentage(10)).to eq(0.00)
      end
    end
    context 'if basic salary is set' do
      it 'should return amount of percentage' do
        expect(@employee_without_last_name.amount_from_percentage(10)).to eq(2000.00)
      end
    end
  end

  describe 'instance method #daily_rate' do
    context 'if basic salary not set' do
      it 'should return 0 as daily rate' do
        expect(@employee.daily_rate(30)).to eq(0.00)
      end
    end
    context 'if basic salary is set' do
      it 'should return daily rate' do
        expect(@employee_without_last_name.daily_rate(30)).to eq(666.67)
      end
    end
  end

  describe 'instance method #hourly_rate' do
    context 'when department working hour not set' do
      it 'should return per_day_date as hourly_rate' do
        expect(@employee_without_last_name.hourly_rate(1000)).to eq(125.00)
      end
    end
    context 'when department working hour already set' do
      it 'should return hourly rate of an employee' do
        expect(@employee.hourly_rate(1000)).to eq(125.00)
      end
    end
  end

  describe 'class method #working_hours_stat' do
    start_date = (Date.today.beginning_of_month - 1.day).beginning_of_month
    it "should return employee's working hours into a hash" do
      expect(Employee.working_hours_stat(@department, start_date, start_date.end_of_month)[:work_hours]).to eq([33])
    end
    it "should return employee's who has attendances into a hash" do
      expect(Employee.working_hours_stat(@department, start_date, start_date.end_of_month)[:employees]).to eq([@employee.first_name])
    end
    # it "should return employee's initialized colors into a hash" do
    #   expect(Employee.working_hours_stat(@department, start_date, start_date.end_of_month)[:colors]).to eq([])
    # end
    it "should return employee'stotal number into a hash" do
      expect(Employee.working_hours_stat(@department, start_date, start_date.end_of_month)[:total]).to eq(1)
    end
  end

  describe 'instance method #short_name' do
    it 'should return employees short name' do
      expect(@employee.short_name).to eq(@employee.full_name.split.map(&:first).join.upcase)
    end
  end

  describe 'instance method #sidebar_menu_generator' do
    it "should return employee's sidebar menus and their attributes" do
      expect(@employee.sidebar_menu_generator[:title]).to eq('Employee Profile')
      expect(@employee.sidebar_menu_generator[:tooltip]).to eq('Employee Profile')
      expect(@employee.sidebar_menu_generator[:menus].size).to eq(4)
      expect(@employee.sidebar_menu_generator[:menus][0][:title]).to eq('Personal Info')
      expect(@employee.sidebar_menu_generator[:menus][1][:title]).to eq('Attendance')
      expect(@employee.sidebar_menu_generator[:menus][2][:title]).to eq('Leave')
      expect(@employee.sidebar_menu_generator[:menus][3][:title]).to eq('Settings')
    end
  end

  describe 'instance method#next_path' do
    context 'when department present' do
      context 'if company next path not present' do
        it 'should return department.company.next_path nil' do
          expect(@employee.next_path).to eq(nil)
        end
      end
    end
    context 'when department not present' do
      it 'should return AppSettings::REGISTRATION_STEPS[:registration]' do
        expect(@employee_without_first_name.next_path).to eq(AppSettings::REGISTRATION_STEPS[:registration])
      end
    end

  end

# class method#import have to be test
  # describe 'class method#import' do
  #   it 'should import a xls file and extract it' do
  #     file = Roo::Spreadsheet.new('spec/employee_template.xlsx')
  #     #file = Roo::Excelx.new('spec/employee_template.xlsx')
  #     expect(Employee.import(file, @department)).to eq(true)
  #   end
  # end


end
