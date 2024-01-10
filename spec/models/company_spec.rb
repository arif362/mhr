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

RSpec.describe Company, type: :model do
  before(:each) do
    @company = FactoryGirl.create(:company)
    @feature_attendance = FactoryGirl.create(:feature, name: 'Attendance', app_module: 'Attendance')
    @feature_payroll = FactoryGirl.create(:feature, name: 'Payroll', app_module: 'Payroll')
    @company_attendance  = FactoryGirl.create(:company_feature, feature_id: @feature_attendance.id, company_id: @company.id)
    @company_payroll = FactoryGirl.create(:company_feature, feature_id: @feature_payroll.id, company_id: @company.id)
  end

  describe 'taken features' do
    it "should return company's taken features" do
      expect(@company.taken_features).to eq([@feature_attendance.name, @feature_payroll.name])
    end
  end

  describe 'sidebar menu generator' do
    it "should return company's sidebar menus and their attributes" do
      expect(@company.sidebar_menu_generator[:title]).to eq('Company Settings')
      expect(@company.sidebar_menu_generator[:tooltip]).to eq('Company Settings')
      expect(@company.sidebar_menu_generator[:menus].size).to eq(4)
      expect(@company.sidebar_menu_generator[:menus][0][:title]).to eq('Information')
      expect(@company.sidebar_menu_generator[:menus][1][:title]).to eq('Departments')
      expect(@company.sidebar_menu_generator[:menus][2][:title]).to eq('Employees')
      expect(@company.sidebar_menu_generator[:menus][3][:title]).to eq('Settings')
    end
  end
end
