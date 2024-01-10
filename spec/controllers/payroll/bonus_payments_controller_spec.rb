# == Schema Information
#
# Table name: payroll_bonus_payments
#
#  id             :integer          not null, primary key
#  reason         :string(255)
#  message        :text(65535)
#  amount         :float(24)
#  employee_id    :integer
#  department_id  :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  payment_method :string(255)
#  date           :date
#

require 'rails_helper'

RSpec.describe Payroll::BonusPaymentsController, type: :controller do

  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id:@company.id)
    @employee = FactoryGirl.create(:employee, role:Employee::ROLE[:admin], basic_salary: 656, department_id:@department.id)
    @payroll_bonus_payment = FactoryGirl.create(:payroll_bonus_payment, department_id:@department.id, employee_id:@employee.id)
    session[:department_id] = @department.id
    sign_in(@employee)
  end

  describe 'get # index' do
    context 'when employee_id params present' do
      it 'should request to index' do
        get :index, employee_id: @employee.id
        expect(response).to be_success
      end
    end

    context 'when employee_id params not present' do
      it 'should request to index' do
        get :index
        expect(response).to be_success
      end
    end
  end

  describe 'get # show' do
    it 'should request to show' do
      xhr :get, :show, id: @payroll_bonus_payment, format: :js
      expect(response).to be_success
    end
  end

  # describe 'get # new' do
  #   it 'should request to new' do
  #     bonus_category = FactoryGirl.create(:payroll_bonus_category)
  #     xhr :get, :new, format: :js, employee_id:@employee.id, bonus_category_id: bonus_category.id
  #     expect(response).to be_success
  #   end
  # end

  describe 'post # create' do
    it 'should request to create' do
      xhr :post, :create, format: :js, payroll_bonus_payment: {amount: 500}
      expect(response).to be_success
    end
  end

  describe 'get # edit' do
    it 'should request to edit' do
      xhr :get, :edit, format: :js, id:@payroll_bonus_payment.id
      expect(response).to be_success
    end
  end

  describe 'put # update' do
    it 'request to update' do
      xhr :put, :update, format: :js, id:@payroll_bonus_payment.id, payroll_bonus_payment: {amount: 500}
      expect(response).to be_success
    end
  end
  describe 'delete # destroy' do
    it 'request to destroy' do
      xhr :delete, :destroy, format: :js, id:@payroll_bonus_payment.id
      expect(response).to be_success
    end
  end


end
