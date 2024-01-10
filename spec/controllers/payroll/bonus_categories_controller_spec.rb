# == Schema Information
#
# Table name: payroll_bonus_categories
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  is_amount     :boolean          default(TRUE)
#  amount        :float(24)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  department_id :integer
#  message       :text(65535)
#

require 'rails_helper'

RSpec.describe Payroll::BonusCategoriesController, type: :controller do
  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id:@company.id)
    @employee = FactoryGirl.create(:employee, role:Employee::ROLE[:admin],basic_salary:50000, department_id:@department.id)
    @payroll_bonus_category = FactoryGirl.create(:payroll_bonus_category, department_id:@department.id)
    session[:department_id] = @department.id
    sign_in(@employee)
  end

  describe 'get#index' do
    it 'should request to index' do
      get :index
      expect(response).to be_success
    end
    it 'should assign @bonus_categories' do
      get :index
      expect(assigns(:bonus_categories)).to eq([@payroll_bonus_category])
    end
  end

  describe 'get # show' do
    it 'should request to show' do
      xhr :get, :show, id: @payroll_bonus_category.id, format: :js
      expect(response).to be_success
    end
  end

  describe 'get # new' do
    it 'should request to new' do
      xhr :get, :new, format: :js
      expect(response).to be_success
    end
    it 'should assign a new @bonus_category' do
      xhr :get, :new, format: :js
      expect(assigns(:bonus_category)).to be_a_new(Payroll::BonusCategory)
    end
  end

  describe 'post # create' do
    context 'without params employee_id' do
      it 'should request to create controller' do
        xhr :post, :create, format: :js, payroll_bonus_category: {name: 'EID'}
        expect(response).to be_success
      end
      it 'should increment by 1 ' do
        count = Payroll::BonusCategory.count
        xhr :post, :create, format: :js, payroll_bonus_category: {name: 'EID'}
        expect(Payroll::BonusCategory.count).to eq(count+1)
      end
    end
    context 'with employee_id params' do
      it 'should request to create controller' do
        xhr :post, :create, format: :js,employee_id:@employee.id, payroll_bonus_category: {name: 'EID'}
        expect(response).to be_success
      end
    end
  end

  describe 'get # edit' do
    it 'should request to edit' do
      xhr :get, :edit, format: :js, id:@payroll_bonus_category.id
      expect(response).to be_success
    end
  end

  describe 'put#update' do
    it 'should request to update' do
      xhr :put, :update, format: :js, id:@payroll_bonus_category.id, payroll_bonus_category: {name: 'EID-ul-azah'}
      expect(response).to be_success
    end
  end

  describe 'delete#destroy' do
    it 'should request to destroy' do
      xhr :delete, :destroy, format: :js, id:@payroll_bonus_category
      expect(response).to be_success
    end
    it 'should decrement by 1' do
      count = Payroll::BonusCategory.count
      xhr :delete, :destroy, format: :js, id:@payroll_bonus_category
      expect(Payroll::BonusCategory.count).to eq(count-1)
    end
  end

end
