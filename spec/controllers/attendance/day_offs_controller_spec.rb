# == Schema Information
#
# Table name: attendance_day_offs
#
#  id            :integer          not null, primary key
#  year          :integer
#  date          :date
#  day_off_type  :string(255)
#  hours         :float(24)
#  title         :string(255)
#  department_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Attendance::DayOffsController, type: :controller do
  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id: @company.id)
    @employee = FactoryGirl.create(:employee, role: Employee::ROLE[:admin], department_id: @department.id)
    @day_off = FactoryGirl.create(:attendance_day_off, department_id: @department.id)
    session[:department_id] = @department.id
    sign_in(@employee)
  end

  describe 'GET #new' do
    it "should create new day off" do
      xhr :get, :new, date: (Date.today + 1.day)
      expect(response).to be_success
      expect(assigns(:day_off)).to be_a_new(Attendance::DayOff)
    end
    it "should find day off" do
      xhr :get, :new, date: Date.today
      expect(response).to be_success
      expect(assigns(:day_off)).to eq(@day_off)
    end
  end

  describe 'POST #create' do
    let(:attendance_day_off) {
      {
          date: Date.today + 1.day,
          day_off_type: 'Holiday',
          title: Faker::Lorem.sentence,
          department_id: @department.id
      }
    }
    it "should create day off" do
      xhr :post, :create, attendance_day_off: attendance_day_off
      expect(response).to be_success
      expect(assigns(:day_off)).to eq(Attendance::DayOff.last)
    end
    it "should create day off" do
      count = Attendance::DayOff.count
      xhr :post, :create, attendance_day_off: attendance_day_off
      expect(assigns(:day_off)).to be_persisted
      expect(count).to eq(Attendance::DayOff.count-1)
    end
  end

  describe 'PUT #update' do
    let(:attendance_day_off) {
      {
          day_off_type: 'Custom Holiday'
      }
    }
    it "should update day off" do
      xhr :put, :update, id: @day_off.id, attendance_day_off: attendance_day_off
      expect(response).to be_success
      expect(assigns(:day_off).day_off_type).to eq('Custom Holiday')
    end
  end

  describe 'DELETE #destroy' do
    it "should destroy day off" do
      count = @department.day_offs.count
      xhr :delete, :destroy, id: @day_off.id
      expect(response).to be_success
      expect(@department.day_offs.count).to eq(count-1)
    end
  end

  describe 'POST #generate' do
    it "should generate day offs of current year" do
      xhr :post, :generate, weekend: Date.today.strftime('%A')
      expect(response).to be_success
      expect(assigns(:day_offs).last[:start].strftime('%A')).to eq(Date.today.strftime('%A'))
    end
  end
end
