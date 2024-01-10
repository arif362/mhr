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

RSpec.describe EmployeesController, type: :controller do
  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id: @company.id)
    @designation = FactoryGirl.create(:designation, department_id: @department.id)
    @employee_one = FactoryGirl.create(:employee, role: Employee::ROLE[:admin], department_id: @department.id)
    @employee_two = FactoryGirl.create(:employee, email: 'arif@arif.com', department_id: @department.id)
    @employee_three = FactoryGirl.create(:employee, department_id: @department.id)
    @access_right_admin = FactoryGirl.create(:access_right, employee_id: @employee_one.id)
    @access_right_admin_01 = FactoryGirl.create(:access_right, employee_id: @employee_two.id)
    @attendance_one = FactoryGirl.create(:attendance, employee_id: @employee_one.id, department_id: @department.id)
    @attendance_two = FactoryGirl.create(:attendance, in_time: Date.today.to_s + " 09:00:00", out_time: Date.today.to_s + " 12:00:00", employee_id: @employee_one.id, department_id: @department.id)
    @attendance_three = FactoryGirl.create(:attendance, in_date: (Date.today - 1).to_s, employee_id: @employee_one.id, department_id: @department.id)
    @attendance_four = FactoryGirl.create(:attendance, employee_id: @employee_two.id, department_id: @department.id)
    session[:department_id] = @department.id
    sign_in(@employee_one)

    @company_2 = FactoryGirl.create(:company)
    @department_2 = FactoryGirl.create(:department, name: 'Office', company_id: @company_2.id)
    @designation_2 = FactoryGirl.create(:designation, department_id: @department_2.id)
    @employee_other_dept = FactoryGirl.create(:employee, department_id: @department_2.id)
  end

  describe 'get#new EmployeesController' do
    context 'if not params[:department].present?' do
      it 'Should request to new for successful response' do
        xhr :get, :new, format: :js
        expect(response).to be_success
      end
      it 'a newly employee should be assigned' do
        xhr :get, :new, format: :js
        expect(assigns(:employee)).to be_a_new(Employee)
      end
      it 'designations should be assigned' do
        xhr :get, :new, format: :js
        expect(assigns(:designations)).to eq([@designation])
      end
    end
    context 'if params[:department].present?' do
      it 'Should request to new for successful response' do
        xhr :get, :new, format: :js, department: @department_2.id
        expect(response).to be_success
      end
      it 'a newly employee should be assigned' do
        xhr :get, :new, format: :js, department: @department_2.id
        expect(assigns(:employee)).to be_a_new(Employee)
      end
      it 'designations should be assigned' do
        xhr :get, :new, format: :js, department: @department_2.id
        expect(assigns(:designations)).to eq([@designation_2])
      end
    end
  end

  describe 'get#index' do
    it 'Should request to EmployeesController index with employee param' do
      get :index, employee: @employee_one.id
      expect(response).to be_success
      # expect(assigns(:employees)).to eq(@department.employees)
    end
    it 'Should request to EmployeesController index without employee param' do
      get :index
      expect(response).to be_success
      #expect(assigns(:employees)).to eq(@department.employees)
    end
    it "should request to EmployeeController index export to PDF without employee params" do
      xhr :get, :index, format: :xls
      expect(response).to be_success
      #expect(assigns(:employees)).to eq(@department.employees)
    end
    it "should request to EmployeeController index export to PDF without employee params" do
      xhr :get, :index, format: :pdf
      expect(response).to be_success
      #expect(assigns(:employees)).to eq(@department.employees)
    end
    it "should request to EmployeeController index export to DOCX without employee params" do
      xhr :get, :index, format: :docx
      expect(response).to be_success
      #expect(assigns(:employees)).to eq(@department.employees)
    end
  end
  describe 'get#attendances' do
    it 'Should request to EmployeesController attendances' do
      get :attendances, employee_id: @employee_one.id
      expect(response).to be_success
    end
    it 'Should request to EmployeesController attendances with employee_id and daterange' do
      xhr :get, :attendances, employee_id: @employee_two.id, daterange: Date.today.beginning_of_month.to_s + ' To ' + Date.today.to_s, format: 'js'
      expect(response).to be_success
      expect(assigns(:employee)).to eq(@employee_two)
      expect(assigns(:todays_attendances)).to eq([@attendance_four])
      expect(assigns(:attendances)).to eq([@attendance_four])
    end

    it 'Should request to EmployeesController attendances with employee_id and without daterange' do
      xhr :get, :attendances, employee_id: @employee_two.id, format: :js
      expect(response).to be_success
      expect(assigns(:employee)).to eq(@employee_two)
      expect(assigns(:todays_attendances)).to eq([@attendance_four])
      expect(assigns(:attendances)).to eq([@attendance_four])
    end
    it 'should be rendered to xls templete' do
      xhr :get, :attendances, employee_id: @employee_two.id, format: :xls
      expect(response).to be_success
      expect(assigns(:employee)).to eq(@employee_two)
      expect(assigns(:attendances)).to eq([@attendance_four])
      expect(response).to render_template('employees/attendances_xls_docx.html.erb')
    end
    it 'should be rendered to pdf templete' do
      xhr :get, :attendances, employee_id: @employee_two.id, format: :pdf
      expect(response).to be_success
      expect(assigns(:employee)).to eq(@employee_two)
      expect(assigns(:attendances)).to eq([@attendance_four])
      expect(response).to render_template('employees/attendances_pdf.html.erb')
    end
    it 'should be rendered to docx templete' do
      xhr :get, :attendances, employee_id: @employee_two.id, format: :docx
      expect(response).to be_success
      expect(assigns(:employee)).to eq(@employee_two)
      expect(assigns(:attendances)).to eq([@attendance_four])
      expect(response).to render_template('employees/attendances_xls_docx.html.erb')
    end
  end

  describe 'add#post' do
    context 'html format' do
      context ' if @employee.save' do
        it 'Should request to EmployeesController add employee saved with employee_account params' do
          request.env["HTTP_REFERER"] = employees_path
          employee_count = Employee.all.count
          employee_params = {first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: 'rubel@gmail.com', password: '123456'}.to_hash
          post :add, employee: employee_params, employee_account: true
          expect(Employee.all.count).to eq(employee_count + 1)
          expect(response).to redirect_to(employees_path)
        end
        it 'Should request to EmployeesController add employee saved without employee_account params' do
          request.env["HTTP_REFERER"] = employees_path
          employee_params = {first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: 'rubel@gmail.com'}.to_hash
          post :add, employee: employee_params
          expect(response).to redirect_to(employees_path)
        end
      end
      context 'if not @employee.save ' do
        it 'Should request to EmployeesController add employee saved without employee_account params' do
          request.env["HTTP_REFERER"] = employees_path
          employee_params = {first_name: Faker::Name.first_name, last_name: Faker::Name.last_name}.to_hash
          post :add, employee: employee_params
          expect(response).to redirect_to(employees_path)
        end
      end
    end
    context 'js format' do
      context ' if @employee.save' do
        it 'Should request to EmployeesController add employee saved with employee_account params' do
          request.env["HTTP_REFERER"] = employees_path
          employee_count = Employee.all.count
          employee_params = {first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: 'rubel@gmail.com', password: '123456'}.to_hash
          xhr :post, :add, format: :js, employee: employee_params, employee_account: true
          expect(Employee.all.count).to eq(employee_count + 1)
          expect(response).to be_success
        end
        it 'Should request to EmployeesController add employee saved without employee_account params' do
          request.env["HTTP_REFERER"] = employees_path
          employee_params = {first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: 'rubel@gmail.com'}.to_hash
          xhr :post, :add, format: :js, employee: employee_params
          expect(response).to be_success
        end
      end

      context 'if not @employee.save ' do
        it 'Should request to EmployeesController add employee saved without employee_account params' do
          request.env["HTTP_REFERER"] = employees_path
          employee_params = {first_name: Faker::Name.first_name, last_name: Faker::Name.last_name}.to_hash
          xhr :post, :add, format: :js, employee: employee_params
          expect(response).to be_success
        end
      end
    end
  end

  describe 'show#get' do
    it 'Should request to EmployeesController show action for success response' do
      get :show, id: @employee_two.id
      expect(response).to be_success
    end
    it 'Should request to EmployeesController show action and assign designations' do
      get :show, id: @employee_two.id
      expect(assigns(:designations)).to eq([@designation])
    end
    it 'Should request to EmployeesController show action and for success response of js format' do
      xhr :get, :show, id: @employee_two.id, format: :js
      expect(response).to be_success
    end
  end

  describe 'profile#get' do
    it 'should request to profile action of employee controller' do
      xhr :get, :profile, employee_id: @employee_two.id, format: :js
      expect(response).to be_success
    end
    it 'should assign an employee ' do
      xhr :get, :profile, employee_id: @employee_two.id, format: :js
      expect(assigns(:employee)).to eq(@employee_two)
    end
  end

  describe 'edit#get' do
    it 'should request to edit action employee controller' do
      xhr :get, :edit, id: @employee_two.id, format: :js
      expect(response).to be_success
    end
    it 'should request to edit action of html format' do
      get :edit, id: @employee_two.id
      expect(response).to render_template(:show)
    end
  end

  describe 'setting#get' do
    it 'should request to settings action of employee controller' do
      get :settings, employee_id: @employee_two.id
      expect(response).to be_success
    end
    it 'should request to settings action of employee controller' do
      get :settings, employee_id: @employee_two.id
      expect(response).to render_template(:show)
    end
    it 'should assign @view template' do
      get :settings, employee_id: @employee_two.id
      expect(assigns(:view)).to eq('employees/passwords/update_password')
    end
    it 'should assign an employee' do
      get :settings, employee_id: @employee_two.id
      expect(assigns(:employee)).to eq(@employee_two)
    end
  end

  describe 'update_info#put' do
    context 'if @employee.update_attributes' do
      it 'should request to update_info action of employee controller' do
        put :update_info, id: @employee_two.id, employee: {first_name: Faker::Name.first_name, last_name: Faker::Name.last_name}
        expect(response).to redirect_to(@employee_two)
      end
      it 'should request to js format of update_info action of employee controller' do
        xhr :put, :update_info, format: :js, id: @employee_two.id, employee: {first_name: Faker::Name.first_name, last_name: Faker::Name.last_name}
        expect(response).to be_success
      end
    end
    context 'if not @employee.update_attributes' do
      it 'should request to update_info action of employee controller' do
        request.env["HTTP_REFERER"] = employees_path
        put :update_info, id: @employee_two.id, employee: {first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: nil}
        expect(response).to redirect_to(employees_path)
      end
      it 'should request to js format of update_info action of employee controller' do
        xhr :put, :update_info, id: @employee_two.id, format: :js, employee: {first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: " "}
        expect(response).to be_success
      end
    end
  end

  describe 'destroy#delete' do
    it 'Should request to EmployeesController destroy current employee' do
      request.env["HTTP_REFERER"] = employee_path(@employee_one)
      delete :destroy, id: @employee_one.id
      expect(response).to redirect_to(employee_path(@employee_one))
    end

    it 'Should request to EmployeesController destroy' do
      request.env["HTTP_REFERER"] = employees_path
      delete :destroy, id: @employee_two.id
      expect(response).to redirect_to(employees_path)
    end

    it 'Should request to EmployeesController destroy ajax' do
      xhr :delete, :destroy, id: @employee_two.id, format: :js
      expect(response).to be_success
    end
  end

  describe 'activation#put' do
    it 'Should request to EmployeesController activation action' do
      request.env["HTTP_REFERER"] = employees_path
      put :activation, id: @employee_two.id
      expect(response).to redirect_to(employees_path)
    end
    it 'Should request to EmployeesController activation action' do
      request.env["HTTP_REFERER"] = employees_path
      xhr :put, :activation, id: @employee_two.id, format: :js
      expect(response).to be_success
    end
  end

  describe 'access_rights' do
    context 'when department, employee id and access rights are present' do
      it "should return employee's of department id" do
        get :access_rights, department_id: @department.id, employee_id: @employee_one.id
        expect(assigns(:employees)).to eq(@department.employees)
      end
      it 'should return employee as employee id' do
        get :access_rights, department_id: @department.id, employee_id: @employee_one.id
        expect(assigns(:employee)).to eq(@employee_one)
      end
      it 'should return access right of employee' do
        get :access_rights, department_id: @department.id, employee_id: @employee_one.id
        expect(assigns(:access_right)).to eq(@access_right_admin)
      end
    end
    context 'when department, employee id and access rights are not present' do
      it "should return employee's of department id" do
        get :access_rights
        expect(assigns(:employees)).to eq(@department.employees)
      end
      it 'should return employee as employee id' do
        get :access_rights
        expect(assigns(:employee)).to eq(@employee_one)
      end
        # it 'should return access right of employee' do
        #   sign_in(@employee_three)
        #   count = AccessRight.all.count
        #   get :access_rights
        #   expect(AccessRight.all.count).to eq(count + 1)
        #   expect(assigns(:access_right)).to eq(@employee_three.access_right)
        # end
    end
  end

   describe 'update_password' do
    context 'when password field are valid' do
      it 'should redirect to root path after sign out' do
        get :update_password, employee: {current_password: 'password', password: '123456', password_confirmation: '123456'}
        expect(response).to redirect_to(root_path)
      end
    end
    context 'when password field are not valid' do
      it 'should redirect to employee_path with current password error' do
        request.env["HTTP_REFERER"] = employee_path(@employee_one)
        get :update_password, employee: {current_password: '123456', password: '123456', password_confirmation: '123456'}
        expect(assigns(:employee).errors.full_messages.first).to eq('Current password is invalid')
        expect(response).to redirect_to(employee_path(@employee_one))
      end
      it 'should redirect to employee_path with password confirmation not match error' do
        request.env["HTTP_REFERER"] = employee_path(@employee_one)
        get :update_password, employee: {current_password: 'password', password: '123456', password_confirmation: '123456789'}
        expect(assigns(:employee).errors.full_messages.first).to eq("Password confirmation doesn't match Password")
        expect(response).to redirect_to(employee_path(@employee_one))
      end
      it 'should redirect to employee_path with password can not be blank error' do
        request.env["HTTP_REFERER"] = employee_path(@employee_one)
        get :update_password, employee: {current_password: '123456', password: '123', password_confirmation: '123'}
        expect(assigns(:employee).errors.full_messages.first).to eq('Password is too short (minimum is 6 characters)')
        expect(response).to redirect_to(employee_path(@employee_one))
      end
     end
   end
end
