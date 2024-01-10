# == Schema Information
#
# Table name: leave_category_years
#
#  id                :integer          not null, primary key
#  department_id     :integer
#  leave_category_id :integer
#  year              :integer
#  days              :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'rails_helper'

RSpec.describe Leave::CategoryYearsController, type: :controller do
  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id: @company.id)
    @employee = FactoryGirl.create(:employee, role: Employee::ROLE[:admin], department_id: @department.id)
    @access_right_admin = FactoryGirl.create(:access_right, employee_id: @employee.id)
    @leave_category_year = FactoryGirl.create(:leave_category_year, department_id: @department.id)
    session[:department_id] = @department.id
    sign_in(@employee)
  end

  describe 'get#new' do
    it 'should request to new action of category_years_controller as js format' do
      xhr :get, :new, format: :js, department_id: @department.id
      expect(response).to be_success
    end
    it 'should request to new action of category_years_controller and assign a new @leave_category_year' do
      xhr :get, :new, format: :js, department_id: @department.id
      expect(assigns(:leave_category_year)).to be_a_new(Leave::CategoryYear)
    end
  end

  describe 'post#create' do
    it 'should request to create action of category_years_controller' do
      xhr :post, :create, format: :js, leave_category_year: {year: Date.today.year}
      expect(response).to be_success
    end
    # it 'should request to create action of category_years_controller and created a newly created leave_category as @leave_category_year ' do
    #   xhr :post, :create, format: :js, leave_category_year: {'year' => Date.today.year}
    #   expect(:leave_category_year).to be_a(Leave::CategoryYear)
    # end
    it 'should view @leave_category_year.department' do
      xhr :post, :create, format: :js, leave_category_year: {year: Date.today.year}
      expect(assigns(:department)).not_to eq(@department)
    end
  end

  describe 'get#edit' do
    it 'should request to edit action of category_years_controller' do
      xhr :get, :edit, format: :js, id: @leave_category_year
      expect(response).to be_success
    end
    it 'should request to edit action of category_years_controller assigns @leave_category_year of current department' do
      xhr :get, :edit, format: :js, id: @leave_category_year.id
      expect(assigns(:department)).to eq(@department)
    end
  end

  describe 'put#update' do
    it 'should request to update action of category_years_controller' do
      xhr :put, :update, format: :js, id: @leave_category_year.id, leave_category_year: {days: 5}
      expect(response).to be_success
    end
    it 'should request to update action of category_years_controller assigns @leave_category_year of current department' do
      xhr :put, :update, format: :js, id: @leave_category_year.id, leave_category_year: {days: 5}
      expect(assigns(:department)).to eq(@department)
    end
  end

  describe 'delete#destroy' do
    it 'hould request to destroy action of category_years_controller' do
      xhr :delete, :destroy, format: :js, id: @leave_category_year.id
      expect(response).to be_success
    end
  end

end
