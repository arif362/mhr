# == Schema Information
#
# Table name: settings
#
#  id            :integer          not null, primary key
#  open_time     :time
#  close_time    :time
#  working_hours :float(24)
#  department_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  time_zone     :string(255)      default("UTC")
#  currency      :string(255)
#

require 'rails_helper'

RSpec.describe SettingsController, type: :controller do
  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id:@company.id)
    @employee = FactoryGirl.create(:employee, role:Employee::ROLE[:admin], department_id:@department.id)
    @setting = FactoryGirl.create(:setting, department_id:@department.id)
    @feature = FactoryGirl.create(:feature)
    session[:department_id] = @department.id
    sign_in(@employee)
  end

  describe 'get#index' do
    it 'should request to SettingsController index method' do
      get :index
      expect(response).to be_success
    end
  end

  describe 'get # features' do
    it 'should request to features' do
      get :features
      expect(response).to be_success
    end
    it 'should assign all features' do
      get :features
      expect(assigns(:features)).to eq([@feature])
    end
  end

  describe 'get # company_feature' do
    it 'should request to company_feature' do
      xhr :get, :company_feature, format: :js
      expect(response).to be_success
    end
      it 'should request to SettingsController company feature' do
        get :company_feature, features: [@feature.id]
        expect(response).to redirect_to(@employee.next_path)
      end
  end

  describe 'get # payment_method' do
      it 'should request to SettingsController payment method' do
        get :payment_method
        expect(response).to redirect_to(employees_path)
      end
  end

  describe 'get# confirm' do
    it 'should request to confirm' do
      xhr :get, :confirm, format: :js
      expect(response).to be_success
    end
  end

  describe 'put # update' do
    it 'should request to update' do
      xhr :put, :update, format: :js, id:@setting.id, setting: {open_time: "10:00:00",close_time: "18:00:00", working_hours: 8}
      expect(response).to be_success
    end
  end

end
