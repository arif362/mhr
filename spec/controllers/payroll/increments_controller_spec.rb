# == Schema Information
#
# Table name: payroll_increments
#
#  id               :integer          not null, primary key
#  employee_id      :integer
#  department_id    :integer
#  present_basic    :float(24)
#  previous_basic   :float(24)
#  is_active        :boolean
#  active_date      :date
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  incremented_by   :string(255)
#  increment_amount :float(24)
#

require 'rails_helper'

RSpec.describe Payroll::IncrementsController, type: :controller do
  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id:@company.id)
    @employee = FactoryGirl.create(:employee, role:Employee::ROLE[:admin],basic_salary:50000, department_id:@department.id)
    @payroll_increment = FactoryGirl.create(:payroll_increment,department_id:@department.id, employee_id:@employee.id)
    session[:department_id] = @department.id
    sign_in(@employee)
  end

  describe 'get # index' do
    it 'should request to index' do
      get :index
      expect(response).to be_success
    end
    it 'should assign @increments' do
      get :index
      expect(assigns(:increments)).to eq([@payroll_increment])
    end
  end

  describe 'get # show' do
    it 'should request to show' do
      xhr :get, :show, format: :js, id:@payroll_increment.id
      expect(response).to be_success
    end
  end

  # describe 'get # new' do
  #   it 'should request to new' do
  #     xhr :get, :new, format: :js
  #     expect(response).to be_success
  #   end
  #   it 'should assign a new @increment' do
  #     xhr :get, :new, format: :js
  #     expect(assigns(:increment)).to be_a_new(Payroll::Increment)
  #   end
  # end

  describe 'post # create' do
    context 'when @increment saved' do
      it 'should request to create' do
        post :create, payroll_increment: {department_id: @department.id, employee_id: @employee.id}
        expect(response).to redirect_to(payroll_increments_path)
      end
    end
    # context 'when @increment not saved' do
    #   it 'should request to create' do
    #     post :create, payroll_increment: {department_id:nil, employee_id:nil}
    #     expect(response).to render_template(:increment.errors)
    #   end
    # end
  end

  describe 'get # edit' do
    it 'should request to edit' do
      xhr :get, :edit, format: :js, id: @payroll_increment.id
      expect(response).to be_success
    end
  end

  describe 'put # update' do
    it 'should request to update' do
      xhr :put, :update, format: :js, id: @payroll_increment.id, payroll_increment: {increment_amount: 45435}
      expect(response).to be_success
    end
  end

  describe 'delete # destroy' do
    it 'should request to destroy' do
      xhr :delete, :destroy, id:@payroll_increment.id
      expect(response).to be_success
    end
  end

  # describe 'get # employee_increment' do
  #   it 'should request to employee_increment' do
  #     xhr :get, :employee_increment, format: :js, employee_id:@employee.id
  #     expect(response).to be_success
  #   end
  # end

  describe 'get # accept' do
    it 'should request to accept' do
      xhr :get, :accept, format: :js, id:@payroll_increment.id
      expect(response).to be_success
    end
  end

end
