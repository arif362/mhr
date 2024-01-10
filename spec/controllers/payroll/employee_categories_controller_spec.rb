# == Schema Information
#
# Table name: payroll_employee_categories
#
#  id          :integer          not null, primary key
#  employee_id :integer
#  category_id :integer
#  amount      :float(24)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  percentage  :float(24)
#

require 'rails_helper'

RSpec.describe Payroll::EmployeeCategoriesController, type: :controller do
  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id:@company.id)
    @employee = FactoryGirl.create(:employee, role:Employee::ROLE[:admin],basic_salary:50000, department_id:@department.id)
    @payroll_category = FactoryGirl.create(:payroll_category, department_id:@department.id)
    @payroll_employee_category = FactoryGirl.create(:payroll_employee_category,employee_id:@employee.id, category_id:@payroll_category.id)
    session[:department_id] = @department.id
    sign_in(@employee)
  end

  describe 'get # new' do
    it 'should request to new' do
      xhr :get, :new, format: :js, employee_id:@employee.id
      expect(response).to be_success
    end
    it 'should assign a new @employee_category' do
      xhr :get, :new, format: :js, employee_id:@employee.id
      expect(assigns(:employee_category)).to be_a_new(Payroll::EmployeeCategory)
    end
  end

  describe 'post # create' do
    it 'should request to create' do
      xhr :post, :create, format: :js, payroll_employee_category: {amount: 500,employee_id:@employee.id, category_id:@payroll_category.id}
      expect(response).to be_success
    end
    it 'should request to create' do
      count = Payroll::EmployeeCategory.count
      xhr :post, :create, format: :js, payroll_employee_category: {amount: 500,employee_id:@employee.id, category_id:@payroll_category.id}
      expect( Payroll::EmployeeCategory.count).to eq(count+1)
    end
  end

  describe 'get # edit' do
    it 'should request to edit' do
      xhr :get, :edit, format: :js, id:@payroll_employee_category.id
      expect(response).to be_success
    end
  end

  describe 'put # update' do
    it 'should request to update' do
      xhr :put, :update, format: :js, id:@payroll_employee_category.id, payroll_employee_category: {amount: 500,employee_id:@employee.id, category_id:@payroll_category.id}
      expect(response).to be_success
    end
  end

  describe 'delete # destroy' do
    it 'should request to destroy' do
      xhr :delete, :destroy, format: :js, id:@payroll_employee_category.id
      expect(response).to be_success
    end
    it 'should decrement by 1' do
      count = Payroll::EmployeeCategory.count
      xhr :delete, :destroy, format: :js, id:@payroll_employee_category.id
      expect( Payroll::EmployeeCategory.count).to eq(count-1)
    end
  end

end
