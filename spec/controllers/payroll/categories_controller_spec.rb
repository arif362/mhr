# == Schema Information
#
# Table name: payroll_categories
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  description   :text(65535)
#  department_id :integer
#  is_add        :boolean          default(TRUE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  is_percentage :boolean          default(TRUE)
#

require 'rails_helper'

RSpec.describe Payroll::CategoriesController, type: :controller do
  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id:@company.id)
    @employee = FactoryGirl.create(:employee, role:Employee::ROLE[:admin],basic_salary:50000, department_id:@department.id)
    @payroll_category = FactoryGirl.create(:payroll_category, department_id:@department.id)
    session[:department_id] = @department.id
    sign_in(@employee)
  end

  describe 'get # index' do
    it 'should request to index action' do
      get :index
      expect(response).to be_success
    end
    it 'should request to index action' do
      xhr :get, :index, format: :xls
      expect(response).to be_success
    end
    it 'should request to index action' do
      xhr :get, :index, format: :pdf
      expect(response).to be_success
    end
    it 'should request to index action' do
      xhr :get, :index, format: :docx
      expect(response).to be_success
    end
  end

  describe 'get # show' do
    it 'should request to show' do
      xhr :get, :show, format: :js, id:@payroll_category.id
      expect(response).to be_success
    end
  end

  describe 'get # new' do
    it 'should request to new' do
      xhr :get, :new, format: :js
      expect(response).to be_success
    end
    it 'should assign a new @category' do
      xhr :get, :new, format: :js
      expect(assigns(:category)).to be_a_new(Payroll::Category)
    end
  end

  describe 'post # create' do
    it 'should request to create' do
      xhr :post, :create, format: :js, payroll_category: {name: 'test', department_id:2}
      expect(response).to be_success
    end
    it 'should increment by 1' do
      count = Payroll::Category.count
      xhr :post, :create, format: :js, payroll_category: {name: 'test', department_id:2}
      expect(Payroll::Category.count).to eq(count+1)
    end
  end

  describe 'get # edit' do
    it 'should request to edit' do
      xhr :get,:edit, format: :js, id:@payroll_category.id
      expect(response).to be_success
    end
  end

  describe 'put # update' do
    it 'should request to update' do
      xhr :put, :update, format: :js, id:@payroll_category.id, payroll_category: {name: 'test'}
      expect(response).to be_success
    end
  end

  describe 'delete # destroy' do
    it 'should request to destroy' do
      xhr :delete, :destroy, format: :js, id:@payroll_category.id
      expect(response).to be_success
    end
    it 'should decrement by 1' do
      count = Payroll::Category.count
      xhr :delete, :destroy, format: :js, id:@payroll_category.id
      expect(Payroll::Category.count).to eq(count-1)
    end
  end

  describe 'get # setup' do
    it 'should request to setup action' do
      get :setup
      expect(response).to redirect_to(payroll_categories_path)
    end
  end

end
