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

RSpec.describe Payroll::SalariesController, type: :controller do
  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id: @company.id)
    @department2 = FactoryGirl.create(:department, name: Faker::Company.name + '1', company_id: @company.id)
    @department.setting.update(open_time: '09:00:00', close_time: '18:00:00', working_hours: 8, time_zone: 'Dhaka', currency: 'bdt')
    @employee = FactoryGirl.create(:employee, department_id: @department.id, basic_salary: 30000.0, role: Employee::ROLE[:admin])
    @employee2 = FactoryGirl.create(:employee, department_id: @department.id, basic_salary: 20000.0)
    @payroll_category1 = FactoryGirl.create(:payroll_category, department_id: @department.id)
    @payroll_category2 = FactoryGirl.create(:payroll_category, department_id: @department.id, name: Faker::Lorem.word + '1', is_add: false)
    @payroll_category3 = FactoryGirl.create(:payroll_category, department_id: @department.id, name: Faker::Lorem.word + '2', is_percentage: false)
    @payroll_category4 = FactoryGirl.create(:payroll_category, department_id: @department.id, name: Faker::Lorem.word + '3', is_add: false, is_percentage: false)
    FactoryGirl.create(:payroll_employee_category, employee_id: @employee.id, category_id: @payroll_category1.id, percentage: 10, amount: nil)
    FactoryGirl.create(:payroll_employee_category, employee_id: @employee.id, category_id: @payroll_category2.id, percentage: 10, amount: nil)
    FactoryGirl.create(:payroll_employee_category, employee_id: @employee.id, category_id: @payroll_category3.id, percentage: nil, amount: 500)
    FactoryGirl.create(:payroll_employee_category, employee_id: @employee.id, category_id: @payroll_category4.id, percentage: nil, amount: 1000)
    @salary = FactoryGirl.create(:payroll_salary, department_id: @department.id, employee_id: @employee.id, is_confirmed: true)
    @salary2 = FactoryGirl.create(:payroll_salary, department_id: @department.id, employee_id: @employee.id, month: Date.today.month == 3 ? 4 : 3)
    session[:department_id] = @department.id
    sign_in(@employee)

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

  describe 'GET #index' do
    context 'when department settings present' do
      context 'when date and employee id parameters present' do
        it 'should return submitted date wise date variables' do
          get :index, date: {month: Date.today.month, year: Date.today.year}, employee_id: @employee.id
          expect(response).to be_success
          expect(assigns(:salary_month)).to eq(Date.today.month)
          expect(assigns(:salary_year)).to eq(Date.today.year)
          expect(assigns(:start_date)).to eq(Date.today.beginning_of_month)
          expect(assigns(:end_date)).to eq(Date.today.end_of_month)
        end

        it 'should return desired employee' do
          get :index, date: {month: Date.today.month, year: Date.today.year}, employee_id: @employee.id
          expect(response).to be_success
          expect(assigns(:employee)).to eq(@employee)
        end

        it 'should return desired employees salaries' do
          get :index, date: {month: Date.today.month, year: Date.today.year}, employee_id: @employee.id
          expect(response).to be_success
          expect(assigns(:salaries)).to eq([@salary, @salary2])
        end

        context 'when employees salary already processed' do
          it 'should return desired employees salary' do
            get :index, date: {month: Date.today.month, year: Date.today.year}, employee_id: @employee.id
            expect(response).to be_success
            expect(assigns(:salary)).to eq(@salary)
          end
        end

        context 'when employees salary already not processed' do
          month = Date.today.month == 1 ? 2 : 1
          it 'should return desired employees new salary object' do
            get :index, date: {month: month, year: Date.today.year}, employee_id: @employee.id
            expect(response).to be_success
            expect(assigns(:salary)).to be_a_new(Payroll::Salary)
          end

          it 'should return employee monthly status' do
            start = Date.new(Date.today.year, month)
            no_of_days = (start.end_of_month - start).to_i + 1
            get :index, date: {month: month, year: Date.today.year}, employee_id: @employee.id
            expect(response).to be_success
            expect(assigns(:employee_status)[:should_worked]).to eq(no_of_days.to_f * 8.0 * 60 * 60)
            expect(assigns(:employee_status)[:office_days]).to eq(no_of_days)
            expect(assigns(:employee_status)[:absent_days]).to eq(no_of_days)
            expect(assigns(:employee_status)[:absent_days]).to eq(no_of_days)
            expect(assigns(:employee_status)[:dayoffs_report][:weekend_days]).to eq(0)
          end

          it 'should return employee payroll categories' do
            get :index, date: {month: month, year: Date.today.year}, employee_id: @employee.id
            expect(response).to be_success
            expect(assigns(:payroll_employee_categories)).to eq(Payroll::EmployeeCategory.all.includes(:category))
          end

          it 'should return total addition which has employee basic salary in it' do
            get :index, date: {month: month, year: Date.today.year}, employee_id: @employee.id
            expect(response).to be_success
            expect(assigns(:total_addition)).to eq(@employee.basic_salary)
          end

          it 'should return total deduction which is 0.0' do
            get :index, date: {month: month, year: Date.today.year}, employee_id: @employee.id
            expect(response).to be_success
            expect(assigns(:total_deduct)).to eq(0.0)
          end

          it 'should return total days of month' do
            start = Date.new(Date.today.year, month)
            no_of_days = (start.end_of_month - start).to_i + 1
            get :index, date: {month: month, year: Date.today.year}, employee_id: @employee.id
            expect(response).to be_success
            expect(assigns(:total_days)).to eq(no_of_days)
          end

          it 'should return employees rate per day' do
            start = Date.new(Date.today.year, Date.today.month == 1 ? 2 : 1)
            no_of_days = (start.end_of_month - start).to_i + 1
            get :index, date: {month: month, year: Date.today.year}, employee_id: @employee.id
            expect(response).to be_success
            expect(assigns(:daily_rate)).to eq((@employee.basic_salary.to_f / no_of_days.to_f).round(2))
          end

          it 'should return employees rate per hour' do
            start = Date.new(Date.today.year, month)
            no_of_days = (start.end_of_month - start).to_i + 1
            rate_per_day = (@employee.basic_salary.to_f / no_of_days.to_f).round(2)
            get :index, date: {month: month, year: Date.today.year}, employee_id: @employee.id
            expect(response).to be_success
            expect(assigns(:hourly_rate)).to eq((rate_per_day / 8.0).round(2))
          end
        end
      end

      context 'when employee id not present' do
        it 'should return departments confirmed salaries' do
          get :index, date: {month: Date.today.month, year: Date.today.year}
          expect(response).to be_success
          expect(assigns(:salaries)).to eq([@salary])
        end
      end

      it 'should return is_unconfirmed true to indicate that department has unconfirmed salaries' do
        get :index, date: {month: Date.today.month, year: Date.today.year}
        expect(response).to be_success
        expect(assigns(:is_unconfirmed)).to eq(true)
      end

      it 'should return is_pending false to indicate that department has unconfirmed salaries' do
        get :index, date: {month: Date.today.month, year: Date.today.year}
        expect(response).to be_success
        expect(assigns(:is_pending)).to eq(false)
      end
    end

    context 'when department settings not present' do
      it 'should redirect to departments general settings path' do
        session[:department_id] = @department2.id
        get :index
        expect(response).to redirect_to(general_departments_path)
      end
    end
  end

  describe 'GET #show' do
    it 'should return salary to show' do
      xhr :get, :show, format: :js, id: @salary.id
      expect(response).to be_success
      expect(assigns(:salary)).to eq(@salary)
      expect(assigns(:employee)).to eq(@employee)
    end
  end

  describe 'GET #payslip' do
    context 'when request format is html' do
      context 'when addition category size is less than deduction category' do
        it 'should return salary to show a payslip' do
          get :payslip, salary_id: @salary.id
          expect(response).to be_success
          expect(assigns(:salary)).to eq(@salary)
          expect(assigns(:employee)).to eq(@employee)
          expect(assigns(:right_border)).to eq(' ')
          expect(assigns(:left_border)).to eq('left-border')
        end
      end

      context 'when addition category size is greater than deduction category' do
        let(:payroll_salary_params) {
          {
              employee_id: @employee.id,
              department_id: @department.id,
              payment_method: Faker::Lorem.word,
              addition_category: {
                  home_allowance_amount: 10000.0,
                  transport_amount: 1000.0,
                  mobile_bill_amount: 500.0,
                  over_time: 1,
                  over_time_amount: 100.0
              },
              total: 26671,
              deduction_category: {
                  unpaid_leave_days: 1,
                  unpaid_leave_deduct: 1129.0,
                  absent_days: 2,
                  absent_deduct: 800.0
              },
              month: Date.today.month,
              year: Date.today.year,
              basic_salary: 20000,
              total_addition: 30100, # total earnings basic salary + addition
              total_deduction: 3429,
              is_confirmed: false
          }
        }
        it 'should return salary to show a payslip' do
          new_salary = Payroll::Salary.create(payroll_salary_params)
          get :payslip, salary_id: new_salary.id
          expect(response).to be_success
          expect(assigns(:salary)).to eq(new_salary)
          expect(assigns(:employee)).to eq(@employee)
          expect(assigns(:right_border)).to eq('right-border')
          expect(assigns(:left_border)).to eq(' ')
        end
      end
    end

    context 'when request format is pdf' do
      it 'should return salary to show a payslip as pdf' do
        xhr :get, :payslip, format: :pdf, salary_id: @salary.id
        expect(response).to be_success
        expect(assigns(:salary)).to eq(@salary)
        expect(assigns(:employee)).to eq(@employee)
        expect(assigns(:right_border)).to eq(' ')
        expect(assigns(:left_border)).to eq('left-border')
      end
    end
  end

  describe 'GET #new' do
    it 'should return new salary object' do
      get :new
      expect(response).to be_success
      expect(assigns(:salary)).to be_a_new(Payroll::Salary)
    end
  end

  describe 'POST #create' do
    let(:payroll_salary_params) {
      {
          employee_id: @employee.id,
          department_id: @department.id,
          payment_method: Faker::Lorem.word,
          addition_category: {
              home_allowance_amount: 10000.0,
              over_time: 1,
              over_time_amount: 100.0
          },
          total: 26671,
          deduction_category: {
              unpaid_leave_days: 1,
              unpaid_leave_deduct: 1129.0,
              late_days: 3,
              late_time: 200.0,
              late_time_deduct: 500.0,
              less_worked_hours: 9.0,
              less_work_deduct: 1000.0,
              absent_days: 2,
              absent_deduct: 800.0
          },
          month: Date.today.month,
          year: Date.today.year,
          basic_salary: 20000,
          total_addition: 30100, # total earnings basic salary + addition
          total_deduction: 3429,
          is_confirmed: false
      }
    }
    it 'should create a new salary' do
      count = Payroll::Salary.all.count
      xhr :post, :create, format: :js, payroll_salary: payroll_salary_params
      expect(Payroll::Salary.count).to eq(count + 1)
      #expect(assigns(:salary)).to eq(Payroll::Salary.last)
    end
  end

  describe 'GET #edit' do
    it 'should return a salary object to edit the object' do
      get :edit, id: @salary.id
      expect(response).to be_success
      expect(assigns(:salary)).to eq(@salary)
      expect(assigns(:employee)).to eq(@employee)
      expect(assigns(:salary_month)).to eq(Date.today.month)
      expect(assigns(:salary_year)).to eq(Date.today.year)
    end
  end

  describe 'PUT #update' do
    context 'when request format is html' do
      it 'should redirect to unconfirmed salaries path' do
        put :update, id: @salary.id, payroll_salary: {total_deduction: 2000.0}
        expect(assigns(:salary).total_deduction).to eq(2000.0)
        expect(assigns(:employee)).to eq(@employee)
        expect(response).to redirect_to(unconfirmed_salaries_payroll_salaries_path)
      end
    end

    context 'when request format is js' do
      it 'should update the salary object' do
        xhr :put, :update, format: :js, id: @salary.id, payroll_salary: {total_addition: 32000.0}
        expect(response).to be_success
        expect(assigns(:salary).total_addition).to eq(32000.0)
        expect(assigns(:employee)).to eq(@employee)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'should destroy a salary object' do
      count = Payroll::Salary.all.count
      xhr :delete, :destroy, format: :js, id: @salary.id
      expect(response).to be_success
      expect(Payroll::Salary.all.count).to eq(count - 1)
    end
  end

  describe 'GET #process_salary' do
    context 'when date params present' do
      it 'should return payable employees' do
        xhr :get, :process_salary, format: :js, date: {month: Date.today.month, year: Date.today.year}
        expect(assigns(:employees)).to eq([@employee2])
      end
    end

    context 'when date params not present' do
      it 'should return payable employees' do
        xhr :get, :process_salary, format: :js
        expect(assigns(:employees)).to eq([@employee, @employee2])
      end
    end
  end

  describe 'GET #process_all' do
    it 'should redirect to salary index path' do
      get :process_all, date: {month: Date.today.month, year: Date.today.year}, employee_ids: [@employee.id, @employee2.id]
      expect(response).to redirect_to(payroll_salaries_path)
    end
  end

  describe 'GET #payable_employees' do
    it 'should return payable employees' do
      xhr :get, :payable_employees, format: :js, month: Date.today.month, year: Date.today.year
      expect(assigns(:employees)).to eq([@employee2])
    end
  end

  describe 'GET #unconfirmed_salaries' do
    it 'should return all unconfirmed salaries of the department' do
      get :unconfirmed_salaries
      expect(assigns(:salaries)).to eq([@salary2])
    end
  end

  describe 'GET #confirm' do
    context 'when request format is html' do
      it 'should redirect to salary index path' do
        unconfirmed_count = Payroll::Salary.all.unconfirmed.count
        get :confirm, salary_ids: [@salary2.id]
        expect(assigns(:salaries)).to eq([@salary2])
        expect(Payroll::Salary.all.unconfirmed.count).to eq(unconfirmed_count - 1)
      end
    end

    context 'when request format is pdf' do
      it 'should return unconfirmed salaries to view in pdf'do
        unconfirmed_count = Payroll::Salary.all.unconfirmed.count
        xhr :get, :confirm, format: :pdf, salary_ids: [@salary2.id]
        expect(response).to be_success
        expect(assigns(:salaries)).to eq([@salary2])
        expect(Payroll::Salary.all.unconfirmed.count).to eq(unconfirmed_count - 1)
      end
    end
  end

  describe 'GET #monthly_sheet' do
    context 'when request format is html' do
      context 'when date params present' do
        it 'should return department salaries of given month' do
          get :monthly_sheet, date: {month: Date.today.month, year: Date.today.year}
          expect(assigns(:month)).to eq(Date.today.month)
          expect(assigns(:year)).to eq(Date.today.year)
          expect(assigns(:salaries)).to eq([@salary])
        end
      end

      context 'when date params not present' do
        it 'should return previous month salaries' do
          prev_month_date = Date.today.beginning_of_month - 1.day
          get :monthly_sheet
          expect(assigns(:month)).to eq(prev_month_date.month)
          expect(assigns(:year)).to eq(prev_month_date.year)
          expect(assigns(:salaries)).to eq([])
        end
      end
    end

    context 'when request format is xls' do
      it 'should return salaries of desired month to view in xls' do
        prev_month_date = Date.today.beginning_of_month - 1.day
        xhr :get, :monthly_sheet, format: :xls
        expect(response).to be_success
        expect(assigns(:month)).to eq(prev_month_date.month)
        expect(assigns(:year)).to eq(prev_month_date.year)
        expect(assigns(:salaries)).to eq([])
      end
    end

    context 'when request format is pdf' do
      it 'should return salaries of desired month to view in pdf' do
        prev_month_date = Date.today.beginning_of_month - 1.day
        xhr :get, :monthly_sheet, format: :pdf
        expect(response).to be_success
        expect(assigns(:month)).to eq(prev_month_date.month)
        expect(assigns(:year)).to eq(prev_month_date.year)
        expect(assigns(:salaries)).to eq([])
      end
    end

    context 'when request format is docx' do
      it 'should return salaries of desired month to view in docx' do
        prev_month_date = Date.today.beginning_of_month - 1.day
        xhr :get, :monthly_sheet, format: :docx
        expect(response).to be_success
        expect(assigns(:month)).to eq(prev_month_date.month)
        expect(assigns(:year)).to eq(prev_month_date.year)
        expect(assigns(:salaries)).to eq([])
      end
    end
  end

end
