# == Schema Information
#
# Table name: departments
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text(65535)
#  image       :string(255)
#  company_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  address     :text(65535)
#  slug        :string(255)
#  city        :string(255)
#  state       :string(255)
#  zip_code    :string(255)
#  country     :string(255)
#  email       :string(255)
#  mobile      :string(255)
#

require 'rails_helper'

RSpec.describe DepartmentsController, type: :controller do
  before(:each) do
    @company_owner=FactoryGirl.create(:employee, role: Employee::ROLE[:admin])
    @company=FactoryGirl.create(:company, employee_id: @company_owner.id)
    @department=FactoryGirl.create(:department, name: 'ICT', company_id: @company.id)
    @company_owner.update_attributes(department_id: @department.id)
    @access_right = FactoryGirl.create(:access_right, employee_id: @company_owner.id)
    @employees = @department.employees.order(id: :desc)
    @employee_list_view = 'employee_list'
    @leave_setting_view = 'settings/leave'
    department_id = session[:department_id]
    sign_in(@company_owner)
  end

  describe 'get#index' do
    it 'should request to index action of DepartmentController as js format' do
      xhr :get, :index, format: :js
      expect(response).to be_success
      expect(assigns(:departments)).to eq([@department])
    end
    it 'should request to index action of DepartmentController as xls format' do
      xhr :get, :index, format: :xls
      expect(response).to be_success
      expect(assigns(:departments)).to eq([@department])
    end
    it 'should request to index action of DepartmentController as pdf format' do
      xhr :get, :index, format: :pdf
      expect(response).to be_success
      expect(assigns(:departments)).to eq([@department])
      expect(response).to render_template('departments/department_list_pdf.html.erb')
    end
    it 'should request to index action of DepartmentController as docx format' do
      xhr :get, :index, format: :docx
      expect(response).to be_success
      expect(assigns(:departments)).to eq([@department])
      expect(response).to render_template('departments/index.docx.erb')
    end
  end

  describe 'get#new' do
    it 'should request to new action of DepartmentController as html format' do
      get :new
      expect(response).to be_success
    end
    it 'should request to new action of DepartmentController as html format' do
      xhr :get, :new, format: :js
      expect(response).to be_success
    end
  end

  describe 'get#edit' do
    it 'should request to edit action of DepartmentController' do
      xhr :get, :edit, format: :js, id: @department.id
      expect(response).to be_success
    end
  end

  describe 'post#create' do
    context 'if department created' do
      it 'should request to create action of DepartmentController' do
        post :create, department: {name: Faker::Name.name, description: Faker::Lorem.paragraph}
        expect(response).to redirect_to(profile_companies_path)
      end
      it 'should request to create action of DepartmentController' do
        xhr :post, :create, format: :js, department: {name: Faker::Name.name, description: Faker::Lorem.paragraph}
        expect(response).to be_success
      end
    end
    context 'if department not created' do
      it 'should request to create action of DepartmentController' do
        xhr :post, :create, format: :js, department: {name: 'ICT', description: Faker::Lorem.paragraph}
        expect(response).to be_success
      end
      it 'should request to create action of DepartmentController' do
        post :create, department: {name: 'ICT', description: Faker::Lorem.paragraph}
        expect(response).to be_success
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'get#show' do
    it 'should request to show action of DepartmentController as html format' do
      get :show, id: @department.id
      expect(response).to be_success
    end
    it 'should request to show action of DepartmentController as js format' do
      xhr :get, :show, format: :js, id: @department.id
      expect(response).to be_success
    end
  end

  describe 'get#employee' do
    it 'should request to employee action of DepartmentController as html' do
      get :employee
      expect(response).to be_success
      expect(response).to render_template(:show)
      expect(assigns(:employees)).to eq(@employees)
      expect(assigns(:view)).to eq(@employee_list_view)
    end
    it 'should request to employee action of DepartmentController as js' do
      xhr :get, :employee, format: :js
      expect(response).to be_success
      expect(response).to render_template(:show)
      expect(assigns(:employees)).to eq(@employees)
      expect(assigns(:view)).to eq(@employee_list_view)
    end
    it 'should request to employee action of DepartmentController as xls' do
      xhr :get, :employee, format: :xls
      expect(response).to be_success
      expect(response).to render_template('employees/employee_list_xls_doc.html.erb')
      expect(assigns(:employees)).to eq(@employees)
      expect(assigns(:view)).to eq(@employee_list_view)
    end
    it 'should request to employee action of DepartmentController as pdf' do
      xhr :get, :employee, format: :pdf
      expect(response).to be_success
      expect(response).to render_template('employees/employee_list_pdf.html.erb')
      expect(assigns(:employees)).to eq(@employees)
      expect(assigns(:view)).to eq(@employee_list_view)
    end
    it 'should request to employee action of DepartmentController as docx' do
      xhr :get, :employee, format: :docx
      expect(response).to be_success
      expect(response).to render_template('employees/employee_list_xls_doc.html.erb')
      expect(assigns(:employees)).to eq(@employees)
      expect(assigns(:view)).to eq(@employee_list_view)
    end
  end

  describe 'get#leave' do
    it 'should request to the leave action of DepartmentController' do
      get :leave
      expect(response).to be_success
      expect(response).to render_template(:show)
    end
    it 'should request to the leave action of DepartmentController and show the view of leave setting' do
      get :leave
      expect(response).to be_success
      expect(response).to render_template(:show)
      expect(assigns(:view)).to eq(@leave_setting_view)
    end
    it 'should request to the leave action of DepartmentController and return leave_categories' do
      @leave_categories = @department.leave_categories
      get :leave
      expect(assigns(:leave_categories)).to eq(@leave_categories)
    end
  end

  describe 'get#budget' do
    it 'should request to budget action of DepartmentController' do
      get :budget
      expect(response).to be_success
    end
    it 'should request to budget action of DepartmentController and response to settings/budget' do
      @budget_view = 'settings/budget'
      @categories = @department.expenses_categories.where(expense_category_id: nil)
      get :budget
      expect(assigns(:view)).to eq(@budget_view)
      expect(assigns(:categories)).to eq(@categories)
    end
    it 'should request to budget action of DepartmentController and response to settings/budget' do
      @budget_view = 'settings/budget'
      get :budget
      expect(response).to render_template(:show)
    end
  end

  describe 'get#general' do
    it 'should request to general action of DepartmentController' do
      @setting = @department.setting
      @general_view = 'settings/general'
      get :general
      expect(assigns(:setting)).to eq(@setting)
      expect(assigns(:view)).to eq(@general_view)
      expect(response).to render_template(:show)
    end
  end

  describe 'get#attendance' do
    it 'should request to attendance action of DepartmentController' do
      @events = @department.events
      @attendance_view = 'settings/attendance'
      get :attendance
      expect(response).to be_success
      expect(assigns(:events)).to eq(@events)
      expect(assigns(:view)).to eq(@attendance_view)
      expect(response).to render_template(:show)
    end
  end

  describe 'get#designation' do
    it 'should request to designation action of DepartmentController as html format' do
      @designations = @department.designations
      @designation_list_view = 'designation_list'
      get :designation
      expect(response).to be_success
      expect(assigns(:designations)).to eq(@designations)
      expect(assigns(:view)).to eq(@designation_list_view)
      expect(response).to render_template(:show)
    end
    it 'should request to designation action of DepartmentController as js format' do
      @designations = @department.designations
      @designation_list_view = 'designation_list'
      xhr :get, :designation, format: :js
      expect(response).to be_success
      expect(assigns(:designations)).to eq(@designations)
      expect(assigns(:view)).to eq(@designation_list_view)
      expect(response).to render_template(:show)
    end
    it 'should request to designation action of DepartmentController as xls format' do
      @designations = @department.designations
      @designation_list_view = 'designation_list'
      xhr :get, :designation, format: :xls
      expect(response).to be_success
      expect(assigns(:designations)).to eq(@designations)
      expect(assigns(:view)).to eq(@designation_list_view)
      expect(response).to render_template('departments/designations_xls_docx.html.erb')
    end
    it 'should request to designation action of DepartmentController as pdf format' do
      @designations = @department.designations
      @designation_list_view = 'designation_list'
      xhr :get, :designation, format: :pdf
      expect(response).to be_success
      expect(assigns(:designations)).to eq(@designations)
      expect(assigns(:view)).to eq(@designation_list_view)
      expect(response).to render_template('departments/designations_pdf.html.erb')
    end
    it 'should request to designation action of DepartmentController as docx format' do
      @designations = @department.designations
      @designation_list_view = 'designation_list'
      xhr :get, :designation, format: :docx
      expect(response).to be_success
      expect(assigns(:designations)).to eq(@designations)
      expect(assigns(:view)).to eq(@designation_list_view)
      expect(response).to render_template('departments/designations_xls_docx.html.erb')
    end
  end

  describe 'put#update' do
    context 'if department updated' do
      it 'should request to updated action of DepartmentController as html' do
        name = Faker::Name.name
        put :update, id: @department.id, department: {name: name, description: Faker::Lorem.paragraph}
        expect(assigns(:department).name).to eq(name)
        expect(response).to redirect_to(@department)
      end
      it 'should request to updated action of DepartmentController as js' do
        name = Faker::Name.name
        xhr :put, :update, format: :js, id: @department.id, department: {name: name, description: Faker::Lorem.paragraph}
        expect(response).to be_success
        expect(assigns(:department).name).to eq(name)
      end
    end
    context 'if department not updated' do
      it 'should request to updated action of DepartmentController as html' do
        put :update, id: @department.id, department: {name: nil, description: Faker::Lorem.paragraph}
        expect(response).to be_success
        expect(response).to render_template(:new)
      end
      it 'should request to updated action of DepartmentController as js' do
        xhr :put, :update, format: :js, id: @department.id, department: {name: nil, description: Faker::Lorem.paragraph}
        expect(response).to be_success
      end
    end
  end

  describe 'delete#destroy' do
    context 'if department of current employee' do
      it 'should request to updated action of DepartmentController as html format' do
        delete :destroy, id: @department.id
        expect(response).to redirect_to(profile_companies_path)
      end
      it 'should request to updated action of DepartmentController as js format' do
        xhr :delete, :destroy, format: :js, id: @department.id
        expect(response).to be_success
      end
    end
    context 'if department of another employee' do
      it 'should request to updated action of DepartmentController as html format' do
        @department_1=FactoryGirl.create(:department, company_id: @company.id)
        delete :destroy, id: @department_1.id
        expect(response).to redirect_to(profile_companies_path)
      end
    end
  end

  describe 'get#switch' do
    context 'if request referrer controller is department and request referrer action is show ' do
      it 'should request to switch action of DepartmentController and redirect to departments show path' do
        request.env["HTTP_REFERER"] = department_path(@department)
        get :switch, id: @department.id
        expect(response).to redirect_to(department_path(@department))
      end
    end
    context 'if request referrer controller is not department and request referrer action is not show ' do
      it 'should request to switch action of DepartmentController and redirect to departments show path' do
        request.env["HTTP_REFERER"] = employees_path
        get :switch, id: @department.id
        expect(response).to redirect_to(employees_path)
      end
    end

  end


  # before(:each) do
  #   @company = FactoryGirl.create(:company)
  #   @department = FactoryGirl.create(:department, company_id: @company.id)
  #   @department_two = FactoryGirl.create(:department, name: 'Department - mirpur', company_id: @company.id)
  #   @employee = FactoryGirl.create(:employee, department_id: @department.id)
  #   @access_right_admin = FactoryGirl.create(:access_right, employee_id: @employee.id)
  #   request.env["HTTP_REFERER"] = profile_companies_path
  #   session[:department_id] = @department.id
  #   sign_in(@employee)
  # end
  #
  # describe 'DepartmentsController' do
  #   it 'should xls request to DepartmentController index' do
  #     xhr :get, :index, format: :xls
  #     expect(response).to be_success
  #   end
  #   it 'should pdf request to DepartmentController index' do
  #     xhr :get, :index, format: :pdf
  #     expect(response).to be_success
  #   end
  #   it 'should docx request to DepartmentController index' do
  #     xhr :get, :index, format: :docx
  #     expect(response).to be_success
  #   end
  #
  #   it 'should request to DepartmentsController new' do
  #     get :new
  #     expect(response).to be_success
  #   end
  #
  #   it 'should request to DepartmentsController create' do
  #     department_params = {name: Faker::Company.name, description: Faker::Lorem.sentences, company_id: @company.id}
  #     post :create, department: department_params
  #     expect(response).to redirect_to(profile_companies_path)
  #     expect(Department.last.id.to_s).to eq(@company.departments.last.id.to_s)
  #   end
  #
  #   it 'Should request to DepartmentsController create when department not saved' do
  #     department_params = {name: @department.name, description: Faker::Lorem.sentences, company_id: @company.id}
  #     post :create, department: department_params
  #     expect(response).to be_success
  #   end
  #
  #   it 'Should request to DepartmentsController show' do
  #     get :show, id: @department_two.id
  #     expect(response).to be_success
  #     expect(assigns(:department)).to eq @department_two
  #     # expect(session[:department_id].to_s).to eq(@department_two.id.to_s)
  #   end
  #
  #   it 'Should request to DepartmentController edit' do
  #     xhr :get, :edit, id: @department.id
  #     expect(response).to be_success
  #   end
  #
  #   it 'should request to DepartmentsController update' do
  #     department_params = {description: Faker::Lorem.sentences}
  #     put :update, id: @department.id, department: department_params
  #     expect(response).to redirect_to(@department)
  #   end
  #
  #   it 'Should request to DepartmentsController update when not updated' do
  #     department_params = {name: @department_two.name}
  #     put :update, id: @department.id, department: department_params
  #     expect(response).to be_success
  #   end
  #
  #   it 'should request to DepartmentsController destroy current employee department' do
  #     delete :destroy, id: @department.id
  #     expect(response).to redirect_to(profile_companies_path)
  #   end
  #
  #   it 'should request to DepartmentsController destroy department which is not current employee department' do
  #     delete :destroy, id: @department_two.id
  #     expect(response).to redirect_to(profile_companies_path)
  #   end
  #
  #   it 'should request to DepartmentsController switch current department' do
  #     get :switch, id: @department_two.id
  #     expect(response).to redirect_to(profile_companies_path)
  #   end
  #
  #   it 'should request to DepartmentsController switch current department redirect to departments show path' do
  #     request.env["HTTP_REFERER"] = department_path(@department)
  #     get :switch, id: @department_two.id
  #     expect(response).to redirect_to(department_path(@department_two))
  #   end
  # end
end
