# == Schema Information
#
# Table name: companies
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  image         :string(255)
#  employee_id   :integer
#  mobile        :string(255)
#  contact_email :string(255)
#  address       :string(255)
#  city          :string(255)
#  state         :string(255)
#  zip_code      :string(255)
#  country       :string(255)
#  next_path     :string(255)
#  custom_url    :string(255)
#  url           :string(255)
#

require 'rails_helper'
require 'faker'

RSpec.describe CompaniesController, type: :controller do
  before(:each) do
    @employee_company_owner = FactoryGirl.create(:employee, role: Employee::ROLE[:admin])
    @company = FactoryGirl.create(:company, employee_id: @employee_company_owner.id)
    @department = FactoryGirl.create(:department, company_id: @company.id)
    @employee_company_owner.update_attributes(department_id: @department.id)
    @access_right_admin = FactoryGirl.create(:access_right, employee_id: @employee_company_owner.id)
    @employee_without_super_admin = FactoryGirl.create(:employee, department_id: @department.id)
    @departments = @company.departments.includes(:employees)
    @view_of_employees = 'companies/templates/company_employees'
    @view_of_departments = 'companies/templates/company_departments'
    session[@department.id] = @employee_company_owner.department.id
    sign_in(@employee_company_owner)
  end

  describe 'CompaniesController get#profile' do
    it 'should request to profile action of CompaniesController as js format' do
      xhr :get, :profile, format: :js
      expect(response).to be_success
      expect(assigns(:company)).to eq(@company)
    end
    it 'should request to profile action of CompaniesController as html format' do
      get :profile
      expect(response).to be_success
      expect(assigns(:company)).to eq(@company)
    end
  end

  describe 'CompaniesController get#employee' do
    it 'should request to employee action of CompaniesController' do
      get :employee
      expect(response).to be_success
      expect(assigns(:departments)).to eq(@departments)
      expect(assigns(:view)).to eq(@view_of_employees)
      expect(response).to render_template('profile')
      expect(assigns(:company)).to eq(@company)
    end
    it 'should request to employee action of CompaniesController as js format' do
      xhr :get, :employee, format: :js
      expect(response).to be_success
      expect(assigns(:departments)).to eq(@departments)
      expect(assigns(:view)).to eq(@view_of_employees)
      expect(response).to render_template('profile')
      expect(assigns(:company)).to eq(@company)
    end
    it 'should request to employee action of CompaniesController as xls format' do
      xhr :get, :employee, format: :xls
      expect(response).to be_success
      expect(assigns(:departments)).to eq(@departments)
      expect(assigns(:view)).to eq(@view_of_employees)
      expect(assigns(:company)).to eq(@company)
    end
    it 'should request to employee action of CompaniesController as pdf format' do
      xhr :get, :employee, format: :pdf
      expect(response).to be_success
      expect(assigns(:departments)).to eq(@departments)
      expect(assigns(:view)).to eq(@view_of_employees)
      expect(assigns(:company)).to eq(@company)
    end
    it 'should request to employee action of CompaniesController as docx format' do
      xhr :get, :employee, format: :docx
      expect(response).to be_success
      expect(assigns(:departments)).to eq(@departments)
      expect(assigns(:view)).to eq(@view_of_employees)
      expect(assigns(:company)).to eq(@company)
    end
  end

  describe 'CompaniesController get#departments' do
    it 'should request to departments action of CompaniesController' do
      get :departments
      expect(response).to be_success
      expect(assigns(:departments)).to eq(@departments)
      expect(response).to render_template('profile')
      expect(assigns(:company)).to eq(@company)
      expect(assigns(:view)).to eq(@view_of_departments)
    end
    it 'should request to departments action of CompaniesController as js format' do
      xhr :get, :departments, format: :js
      expect(response).to be_success
      expect(assigns(:company)).to eq(@company)
      expect(assigns(:departments)).to eq(@departments)
      expect(assigns(:view)).to eq(@view_of_departments)
      expect(response).to render_template('profile')
    end
    it 'should request to departments action of CompaniesController as xls format' do
      xhr :get, :departments, format: :xls
      expect(response).to be_success
      expect(assigns(:company)).to eq(@company)
      expect(assigns(:departments)).to eq(@departments)
      expect(assigns(:view)).to eq(@view_of_departments)
    end
    it 'should request to departments action of CompaniesController as pdf format' do
      xhr :get, :departments, format: :pdf
      expect(response).to be_success
      expect(assigns(:company)).to eq(@company)
      expect(assigns(:departments)).to eq(@departments)
      expect(assigns(:view)).to eq(@view_of_departments)
    end
    it 'should request to departments action of CompaniesController as docx format' do
      xhr :get, :departments, format: :docx
      expect(response).to be_success
      expect(assigns(:company)).to eq(@company)
      expect(assigns(:departments)).to eq(@departments)
      expect(assigns(:view)).to eq(@view_of_departments)
    end
  end

  describe 'CompaniesController get#new' do
    context 'if current_employee super_admin' do
      it 'should request to new action of CompaniesController' do
        get :new
        expect(response).to be_success
      end
    end
    context 'if current_employee not super_admin' do
      it 'should request to new action of CompaniesController' do
        request.env["HTTP_REFERER"] = employees_path
        sign_out(@employee_company_owner)
        sign_in(@employee_without_super_admin)

        get :new
        expect(response).to redirect_to(employees_path)
      end
    end
  end

  describe 'CompaniesController post#create' do
    it 'should request to create action of CompaniesController' do
      post :create, company: {name: Faker::Name.name, mobile: Faker::PhoneNumber.phone_number, address: Faker::Address.secondary_address, zip_code: Faker::Address.zip_code, country: 'Bangladesh'}
      expect(response).to redirect_to(@company.next_path)
    end
  end

  describe 'get#edit' do
    it "should request to edit action of CompaniesController" do
      xhr :get, :edit, id: @company.id, format: :js
      expect(response).to be_success
    end
  end

  describe 'put#update' do
    context 'if company params update' do
      it "should request to update action of CompaniesController" do
        xhr :put, :update, id: @company.id, company: {address: Faker::Address.secondary_address}
        expect(response).to redirect_to(profile_companies_path)
      end
    end
    context 'if company params update' do
      it "should request to update action of CompaniesController" do
        xhr :put, :update, id: @company.id, company: {address: ''}
        expect(response).to redirect_to(profile_companies_path)
      end
    end

  end
  #
  #  describe 'CompaniesController #update' do
  #   # TODO: will have to fix company update error test code
  #   context 'For valid params' do
  #     let(:new_attributes) {
  #       {
  #           'name': Faker::Company.name,
  #           'mobile': Faker::PhoneNumber.phone_number,
  #           'address': Faker::Address.secondary_address,
  #           'city': Faker::Address.city,
  #           'state': Faker::Address.state
  #
  #       }
  #     }
  #     it 'should request to CompaniesController update successful and assigns @company to company' do
  #       put :update, id: @company.to_param, company: new_attributes
  #       expect(assigns(:company)).to eq(@company)
  #     end
  #     it 'should request to CompaniesController update successful and redirect to the profile company path' do
  #       put :update, id: @company.to_param, company: new_attributes
  #       expect(response).to redirect_to(profile_companies_path)
  #     end
  #   end
  #   context 'for invalid params' do
  #     let(:new_invalid_params){
  #       {
  #           'name': '',
  #           'mobile': Faker::PhoneNumber.phone_number,
  #           'address': Faker::Address.secondary_address
  #       }
  #     }
  #     it 'should request to CompaniesController update unsuccessful' do
  #       put :update, id: @company.to_param, company: new_invalid_params
  #       expect(response).to redirect_to(profile_companies_path)
  #     end
  #   end
  # end

end
