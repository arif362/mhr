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
require 'cancan'

RSpec.describe Attendance::AttendancesController, type: :controller do
  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id: @company.id)
    @feature = FactoryGirl.create(:feature, name: 'Attendance', app_module: 'Attendance')
    @company_feature = FactoryGirl.create(:company_feature, company_id: @company.id, feature_id: @feature.id)
    @employee = FactoryGirl.create(:employee, role: Employee::ROLE[:admin], department_id: @department.id)
    @employee_absent = FactoryGirl.create(:employee, department_id: @department.id)
    @employee_with_access_right = FactoryGirl.create(:employee, is_active: true, department_id: @department.id)
    @employee_without_access_right = FactoryGirl.create(:employee, is_active: true, department_id: @department.id)
    @attendance = FactoryGirl.create(:attendance, employee_id: @employee.id, department_id: @department.id)
    access_right_permission = {"Attendance" => {"attendances" => 1}}
    @access_right = FactoryGirl.create(:access_right, employee_id: @employee_with_access_right.id, permissions: access_right_permission)
    session[:department_id] = @department.id
    sign_in(@employee)

    @date = Date.today -1
  end

  describe 'AttendancesController, get#index' do
    context 'Admin access of attendance module' do
      context 'if date present as parameter' do
        it 'should request to AttendancesController index with date param' do
          get :index, date: @date
          expect(response).to be_success
          expect(assigns(:attendances)).to eq([@attendance])
        end
        it 'should assign the previous day' do
          get :index, date: @date
          expect(assigns(:prev)).to eq(@date-1)
        end
        it 'should assign the @next day' do
          get :index, date: @date
          expect(assigns(:next)).to eq(@date + 1)
        end
      end
      context 'should assign current date' do
        it 'should request to AttendancesController index without date param' do
          get :index
          expect(response).to be_success
          expect(assigns(:attendances)).to eq([@attendance])
        end
      end
      it "should request to AttendanceController index export to xls" do
        xhr :get, :index, format: :xls, date: @date
        expect(response).to be_success
        expect(response).to render_template('attendance/attendances/attendance_list_xls_docx.html.erb')
      end

      it "should request to AttendanceController index export to PDF" do
        xhr :get, :index, format: :pdf, date: @date
        expect(response).to be_success
        expect(response).to render_template('attendance/attendances/attendance_list_pdf.html.erb')
      end

      it "should request to AttendanceController index export to DOCX" do
        xhr :get, :index, format: :docx, date: @date
        expect(response).to be_success
        expect(response).to render_template('attendance/attendances/attendance_list_xls_docx.html.erb')
      end
    end

    # context 'Employee with access_right of attendance module' do
    #
    #   it 'should request to AttendancesController index with date param' do
    #
    #     sign_in(@employee_with_access_right)
    #     get :index, date: @date
    #     expect(response).to be_success
    #     # expect(assigns(:attendances)).to eq([@attendance])
    #   end
    #
    #   it 'should request to AttendancesController index without date param' do
    #     get :index
    #     expect(response).to be_success
    #     expect(assigns(:attendances)).to eq([@attendance])
    #   end
    #
    #   it "should request to AttendanceController index export to xls" do
    #     xhr :get, :index, format: :xls, date: @date
    #     expect(response).to be_success
    #     expect(response).to render_template('attendance/attendances/attendance_list_xls_docx.html.erb')
    #   end
    #
    #   it "should request to AttendanceController index export to PDF" do
    #     xhr :get, :index, format: :pdf, date: @date
    #     expect(response).to be_success
    #     expect(response).to render_template('attendance/attendances/attendance_list_pdf.html.erb')
    #   end
    #
    #   it "should request to AttendanceController index export to DOCX" do
    #     xhr :get, :index, format: :docx, date: @date
    #     expect(response).to be_success
    #     expect(response).to render_template('attendance/attendances/attendance_list_xls_docx.html.erb')
    #   end
    # end

    context 'Employee without access_right of attendance module' do
      it 'should request to AttendancesController index with date param' do
        request.env["HTTP_REFERER"] = employee_path(@employee_without_access_right)
        sign_in(@employee_without_access_right)
        get :index, date: @date
        expect(response).to redirect_to(employee_path(@employee_without_access_right))
      end

      it 'should request to AttendancesController index without date param' do
        request.env["HTTP_REFERER"] = employee_path(@employee_without_access_right)
        sign_in(@employee_without_access_right)
        get :index
        expect(response).to redirect_to(employee_path(@employee_without_access_right))
      end
    end
  end

  describe 'AttendancesController, get#new' do
    context 'Admin access of attendance module' do
      it 'Should request to AttendancesController new action' do
        xhr :get, :new, format: :js
        expect(response).to be_success
      end
      it 'Should assign a new attendance' do
        xhr :get, :new, format: :js
        expect(assigns(:attendance)).to be_a_new(Attendance::Attendance)
      end
      it 'Should assign a existence employee' do
        xhr :get, :new, format: :js, employee_id: @employee.id
        expect(assigns(:employee)).to eq(@employee)
      end
      context 'if date is selected as parameter' do
        it 'Should assign a date of params' do
          @date = Date.today -1
          xhr :get, :new, format: :js, selected_date: @date
          expect(assigns(:date)).to eq(@date)
        end
      end
      context 'should assign current date' do
        it 'Should assign a date of params' do
          xhr :get, :new, format: :js
          expect(assigns(:date)).to eq(@date)
        end
      end
    end

  end

  describe 'AttendanceController, get#edit' do
    context 'Admin access of attendance module' do
      it "should request to AttendanceController edit" do
        xhr :get, :edit, id: @attendance.id, format: :js
        expect(response).to be_success
      end
    end

  end

  describe 'AttendanceController, post#create' do
    context 'Admin access of attendance module' do
      context 'if attendance save' do
        it 'should request to AttendancesController create' do
          post :create, employee_id: @employee.id, in_date: Date.today, attendance_attendance: {in_time: Date.today.to_s + " 09:30:00", out_time: Date.today.to_s + " 10:30:00"}
          expect(response).to redirect_to(employee_attendances_path(@employee))
        end
        it 'should assign an existing employee of parmeter id' do
          post :create, employee_id: @employee.id, in_date: Date.today, attendance_attendance: {in_time: Date.today.to_s + " 09:30:00", out_time: Date.today.to_s + " 10:30:00"}
          expect(assigns(:employee)).to eq(@employee)
        end
        it 'should request to AttendancesController create as JS format' do
          xhr :post, :create, format: :js, employee_id: @employee.id, in_date: Date.today, attendance_attendance: {in_time: Date.today.to_s + " 09:30:00", out_time: Date.today.to_s + " 10:30:00"}
          expect(response).to be_success
          expect(assigns(:employee)).to eq(@employee)
        end
      end
      context 'if attendance not saved' do
        it 'should request to AttendancesController create' do
          post :create, employee_id: @employee.id, attendance_attendance: {in_time: Date.today.to_s + " 09:30:00", out_time: Date.today.to_s + " 10:30:00"}
          expect(response).to render_template(:new)
        end
        it 'should assign an existing employee of parmeter id' do
          post :create, employee_id: @employee.id, attendance_attendance: {in_time: Date.today.to_s + " 09:30:00", out_time: Date.today.to_s + " 10:30:00"}
          expect(assigns(:employee)).to eq(@employee)
        end
        it 'should request to AttendancesController create as JS format' do
          xhr :post, :create, format: :js, employee_id: @employee.id, attendance_attendance: {in_time: Date.today.to_s + " 09:30:00", out_time: Date.today.to_s + " 10:30:00"}
          expect(response).to be_success
          expect(assigns(:employee)).to eq(@employee)
        end
      end
    end
  end

  describe 'put#update' do
    context 'Admin access of attendance module' do
      context 'Without from_edit params' do
        it 'should request to update action' do
          put :update, id: @attendance.id
          expect(response).to redirect_to(employee_attendances_path(@employee))
        end
        it 'should assign attendance id as given parameter' do
          put :update, id: @attendance.id
          expect(assigns(:attendance)).to eq(@attendance)
        end
      end
      context 'with from_edit param' do
        context 'if attendance is updated' do
          it 'should request to update action of AttendanceController  ' do
            put :update, id: @attendance.id, from_edit: 'yes', in_time: Date.today.to_s + " 10:00:00", out_time: Date.today.to_s + " 12:00:00"
            expect(response).to redirect_to(employee_attendances_path(@employee))
            expect(assigns(:attendance).in_time).to eq(@attendance.in_date.to_s + ' ' + " 10:00:00")
            expect(assigns(:attendance).out_time).to eq(@attendance.in_date.to_s + ' ' + " 12:00:00")
          end
          it 'should assign attendance id as given parameter' do
            put :update, id: @attendance.id, from_edit: 'yes', in_time: Date.today.to_s + " 09:00:00", out_time: Date.today.to_s + " 12:00:00"
            expect(assigns(:attendance)).to eq(@attendance)
          end
        end
        context 'if attendance not updated ' do
          it 'should request to update action of AttendanceController  ' do
            put :update, id: @attendance.id, from_edit: 'yes', in_time: nil, out_time: Date.today.to_s + " 12:00:00"
            expect(response).to render_template(:edit)
          end
          it 'should assign attendance id as given parameter' do
            put :update, id: @attendance.id, from_edit: 'yes', in_time: nil, out_time: Date.today.to_s + " 12:00:00"
            expect(assigns(:attendance)).to eq(@attendance)
          end
        end
      end
    end
  end

  describe 'delete#destroy' do
    it 'should request to destroy' do
      xhr :delete, :destroy, format: :js, id: @attendance.id
      expect(response).to be_success
    end
    it 'should request to destroy' do
      count = Attendance::Attendance.count
      xhr :delete, :destroy, format: :js, id: @attendance.id
      expect(Attendance::Attendance.count).to eq(count-1)
    end
  end

  describe 'get#in' do
    it 'should request to in action of attendance controller' do
      xhr :get, :in, format: :js
      expect(response).to be_success
      expect(assigns(:attendance)).to eq(Attendance::Attendance.last)
    end
    it 'should assign current attendance date' do
      xhr :get, :in, format: :js
      expect(assigns(:attendance_date)).to eq(Date.today)
    end
    it 'should assign current employees attendance date' do
      xhr :get, :in, format: :js
      expect(assigns(:attendances)).to eq([@attendance])
    end
    it 'should response @already_in true ' do
      @attendance_1 = FactoryGirl.create(:attendance, employee_id: @employee.id, department_id: @department.id, out_time: nil)
      xhr :get, :in, format: :js
      expect(assigns(:already_in)).to eq(true)
    end
    it 'should response @already_in false ' do
      xhr :get, :in, format: :js
      expect(assigns(:already_in)).to eq(false)
    end
    it 'should create a new in of attendance so one attendance increased ' do
      count = Attendance::Attendance.count
      xhr :get, :in, format: :js
      expect(Attendance::Attendance.count).to eq(count+1)
    end
    it 'assigns a newly created leave_category as @attendance ' do
      xhr :get, :in, format: :js
      expect(assigns(:attendance)).to be_persisted
    end
  end

  describe 'get#out' do
    context 'if @attendance is present' do
      it 'should assign @attendance_date as current_date' do
        xhr :get, :out, format: :js, id: @attendance.id
        expect(assigns(:attendance_date)).to eq(Date.today)
      end
      it 'should assign @attendances' do
        xhr :get, :out, format: :js, id: @attendance.id
        expect(assigns(:attendances)).to eq([@attendance])
      end

      context ' if @attendances.present? && @attendances.length > 0 && @attendances.last.out_time.present?' do
        it 'should response @already_out true ' do
          xhr :get, :out, format: :js, id: @attendance.id
          expect(assigns(:already_out)).to eq(true)
        end
      end
      context 'if not @attendances.present? && @attendances.length > 0 && @attendances.last.out_time.present?' do
        it 'should response @already_out false ' do
          @attendance_1 = FactoryGirl.create(:attendance, employee_id: @employee.id, department_id: @department.id, out_time: nil)
          xhr :get, :out, format: :js, id: @attendance_1.id
          expect(assigns(:already_out)).to eq(false)
        end
      end
      it 'should response to be success' do
        xhr :get, :out, format: :js, id: @attendance.id
        expect(response).to be_success
      end
    end
  end

  describe 'get#history' do
    it 'should request to AttendancesController history with daterange' do
      get :history, daterange: Date.today.beginning_of_month.to_s + ' To ' + Date.today.to_s
      expect(response).to be_success
      expect(assigns(:attendances).first.total_duration).to eq(10800)
      #expect(assigns(:absent_employees)).to eq([@employee_absent])
    end
    it 'should response to be success with the params of daterange' do
      daterange = Date.today.beginning_of_month.strftime('%B %d, %Y') + ' to ' + Date.today.strftime('%B %d, %Y')
      get :history, daterange: daterange
      expect(response).to be_success
    end
    it 'should request to history action of AttendanceController' do
      get :history
      expect(response).to be_success
    end
    it 'should response to xls format and rendered to xls template' do
      xhr :get, :history, format: :xls
      expect(response).to render_template('attendance/attendances/history_xls_docx.html.erb')
    end
    it 'should response to pdf format and rendered to pdf template' do
      xhr :get, :history, format: :pdf
      expect(response).to render_template('attendance/attendances/history_pdf.html.erb')
    end
    it 'should response to docx format and rendered to docx template' do
      xhr :get, :history, format: :docx
      expect(response).to render_template('attendance/attendances/history_xls_docx.html.erb')
    end
  end

  describe 'get#report' do
    context 'if  check_department_settings is true' do
      it 'should response to success' do
        @setting = Setting.find_by(department_id: @department.id)
        @setting.update_attributes(open_time: "10:00:00", working_hours: 8)
        get :report
        expect(response).to be_success
      end
      context 'when params not present' do
        it 'should assign the default start date without params' do
          @setting = Setting.find_by(department_id: @department.id)
          @setting.update_attributes(open_time: "10:00:00", working_hours: 8)
          get :report
          expect(assigns(:start_date)).to eq(Date.today.beginning_of_month)
        end
      end
      context 'when date params present' do
        it 'should assign start date with params' do
          @setting = Setting.find_by(department_id: @department.id)
          @setting.update_attributes(open_time: "10:00:00", working_hours: 8)
          get :report, date: {year: Date.today.year, month: Date.today.month}
          expect(assigns(:start_date)).to eq(Date.today.beginning_of_month)
        end
        it 'should assign end date with params' do
          @setting = Setting.find_by(department_id: @department.id)
          @setting.update_attributes(open_time: "10:00:00", working_hours: 8)
          get :report, date: {year: Date.today.year, month: Date.today.month}
          expect(assigns(:end_date)).to eq(Date.today.end_of_month)
        end
      end
      it 'should render to xls templete' do
        @setting = Setting.find_by(department_id: @department.id)
        @setting.update_attributes(open_time: "10:00:00", working_hours: 8)
        xhr :get, :report, format: :xls
        expect(response).to render_template('attendance/attendances/report_xls_docx.html.erb')
      end
      it 'should render to pdf templete' do
        @setting = Setting.find_by(department_id: @department.id)
        @setting.update_attributes(open_time: "10:00:00", working_hours: 8)
        xhr :get, :report, format: :pdf
        expect(response).to render_template('attendance/attendances/report_pdf.html.erb')
      end
      it 'should render to docx templete' do
        @setting = Setting.find_by(department_id: @department.id)
        @setting.update_attributes(open_time: "10:00:00", working_hours: 8)
        xhr :get, :report, format: :docx
        expect(response).to render_template('attendance/attendances/report_xls_docx.html.erb')
      end
    end
    context 'when check_department_settings is false' do
      it 'should redirect to general_departments_path' do
        get :report
        expect(response).to redirect_to(general_departments_path)
      end
    end
  end

  describe 'get#employee_wise_report' do
    context 'when check_department_settings is false' do
      it 'should request to employee_wise_report of AttendanceController' do
        get :employee_wise_report
        expect(response).to redirect_to(general_departments_path)
      end
    end
    context 'when check_department_settings is true' do
      it 'should response to success' do
        @setting = Setting.find_by(department_id: @department.id)
        @setting.update_attributes(open_time: "10:00:00", working_hours: 8)
        get :employee_wise_report
        expect(response).to be_success
      end
      context 'when params[:employee_id] find' do
        it 'should assign the employee of given parameter' do
          @setting = Setting.find_by(department_id: @department.id)
          @setting.update_attributes(open_time: "10:00:00", working_hours: 8)
          get :employee_wise_report, employee_id: @employee_absent.id
          expect(assigns(:employee)).to eq(@employee_absent)
        end
      end
      context 'when params[:employee_id] not find' do
        it 'should assign the employee of given parameter' do
          @setting = Setting.find_by(department_id: @department.id)
          @setting.update_attributes(open_time: "10:00:00", working_hours: 8)
          get :employee_wise_report
          expect(assigns(:employee)).to eq(@employee)
        end
      end
      context 'when params[:date] is not present' do
        it 'should assign start_date' do
          @setting = Setting.find_by(department_id: @department.id)
          @setting.update_attributes(open_time: "10:00:00", working_hours: 8)
          get :employee_wise_report
          expect(assigns(:start_date)).to eq(Date.today.beginning_of_month)
        end
        it 'should assign end_date' do
          @setting = Setting.find_by(department_id: @department.id)
          @setting.update_attributes(open_time: "10:00:00", working_hours: 8)
          get :employee_wise_report
          expect(assigns(:end_date)).to eq(Date.today)
        end
      end
      context 'when params[:date] is present' do
        it 'should assign start_date' do
          @setting = Setting.find_by(department_id: @department.id)
          @setting.update_attributes(open_time: "10:00:00", working_hours: 8)
          get :employee_wise_report, date: {year: Date.today.year, month: Date.today.month}
          expect(assigns(:start_date)).to eq(Date.today.beginning_of_month)
        end
        it 'should assign end_date' do
          @setting = Setting.find_by(department_id: @department.id)
          @setting.update_attributes(open_time: "10:00:00", working_hours: 8)
          get :employee_wise_report, date: {year: Date.today.year, month: Date.today.month}
          expect(assigns(:end_date)).to eq(Date.today.end_of_month)
        end
      end

      it 'should rendered to xls format' do
        @setting = Setting.find_by(department_id: @department.id)
        @setting.update_attributes(open_time: "10:00:00", working_hours: 8)
        xhr :get, :employee_wise_report, format: :xls
        expect(response).to render_template('attendance/attendances/employee_wise_report_xls_docx.html.erb')
      end
      it 'should rendered to pdf format' do
        @setting = Setting.find_by(department_id: @department.id)
        @setting.update_attributes(open_time: "10:00:00", working_hours: 8)
        xhr :get, :employee_wise_report, format: :pdf
        expect(response).to render_template('attendance/attendances/employee_wise_report_pdf.html.erb')
      end
      it 'should rendered to docx format' do
        @setting = Setting.find_by(department_id: @department.id)
        @setting.update_attributes(open_time: "10:00:00", working_hours: 8)
        xhr :get, :employee_wise_report, format: :docx
        expect(response).to render_template('attendance/attendances/employee_wise_report_xls_docx.html.erb')
      end
    end
  end
end
