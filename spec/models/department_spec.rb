# == Schema Information
#
# Table name: departments
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text(65535)
#  image       :string(255)
#  company_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  address     :text(65535)
#  slug        :string(255)
#  city        :string(255)
#  state       :string(255)
#  zip_code    :string(255)
#  country     :string(255)
#  email       :string(255)
#  mobile      :string(255)
#

require 'rails_helper'

RSpec.describe Department, type: :model do
  before(:each) do
    @company=FactoryGirl.create(:company)
    @department_created_at_present=FactoryGirl.create(:department, company_id: @company.id)
    @department_created_at_not_present=FactoryGirl.create(:department, name: 'Head office', company_id: @company.id, created_at: nil)
  end

  describe 'instance method year' do
    context 'If department created_at present' do
      it 'should return year of created_at of department' do
        expect(@department_created_at_present.year).to eq(@department_created_at_present.created_at.strftime('%Y').to_i)
      end
    end
    context 'If department created_at not present' do
      it 'should return year of created_at of department' do
        expect(@department_created_at_not_present.year).to eq(Date.today.year)
      end
    end
  end

  describe 'instance method events' do
    it 'should return day_offs of the department' do
      expect(@department_created_at_present.events).to eq(@department_created_at_present.day_offs.order(date: :asc))
    end
    context 'if day_offs present' do
      it 'should return day_offs of the department' do
        day_offs = @department_created_at_present.day_offs.order(date: :asc)
        expect(@department_created_at_present.events).to eq(day_offs.collect { |day_off| {id: day_off.id, title: day_off.title, start: day_off.date.strftime('%Y-%m-%d'), allDayDefault: true} })
      end
    end
    context 'if day_offs not present' do
      it 'should return day_offs of the department' do
        expect(@department_created_at_present.events).to eq([])
      end
    end
  end

  describe 'instance method sidebar_menu_generator' do
    it 'should return menus' do
      expect(@department_created_at_present.sidebar_menu_generator[:title]).to eq('Department Settings')
      expect(@department_created_at_present.sidebar_menu_generator[:tooltip]).to eq('Department Settings')
      expect(@department_created_at_present.sidebar_menu_generator[:menus].size).to eq(7)
      expect(@department_created_at_present.sidebar_menu_generator[:menus][0][:title]).to eq('Information')
      expect(@department_created_at_present.sidebar_menu_generator[:menus][0][:url]).to eq("/departments/#{@department_created_at_present.id}")
      expect(@department_created_at_present.sidebar_menu_generator[:menus][0][:icon]).to eq('fa-info-circle')
      expect(@department_created_at_present.sidebar_menu_generator[:menus][0][:class]).to eq('information sidebar-menu-active')
      expect(@department_created_at_present.sidebar_menu_generator[:menus][0][:tooltip]).to eq('Information')
      expect(@department_created_at_present.sidebar_menu_generator[:menus][1][:title]).to eq('Employees')
      expect(@department_created_at_present.sidebar_menu_generator[:menus][1][:url]).to eq('/departments/settings/employee')
      expect(@department_created_at_present.sidebar_menu_generator[:menus][1][:icon]).to eq('fa-user-circle')
      expect(@department_created_at_present.sidebar_menu_generator[:menus][1][:class]).to eq('employee')
      expect(@department_created_at_present.sidebar_menu_generator[:menus][1][:tooltip]).to eq('Employees')
      expect(@department_created_at_present.sidebar_menu_generator[:menus][2][:title]).to eq('Designation')
      expect(@department_created_at_present.sidebar_menu_generator[:menus][2][:url]).to eq('/departments/settings/designation')
      expect(@department_created_at_present.sidebar_menu_generator[:menus][2][:icon]).to eq('fa-id-badge')
      expect(@department_created_at_present.sidebar_menu_generator[:menus][2][:class]).to eq('designation')
      expect(@department_created_at_present.sidebar_menu_generator[:menus][2][:tooltip]).to eq('Designations')
      expect(@department_created_at_present.sidebar_menu_generator[:menus][3][:title]).to eq('General Settings')
      expect(@department_created_at_present.sidebar_menu_generator[:menus][3][:url]).to eq('/departments/settings/general')
      expect(@department_created_at_present.sidebar_menu_generator[:menus][3][:icon]).to eq('fa-cog')
      expect(@department_created_at_present.sidebar_menu_generator[:menus][3][:class]).to eq('general')
      expect(@department_created_at_present.sidebar_menu_generator[:menus][3][:tooltip]).to eq('General Settings')
      expect(@department_created_at_present.sidebar_menu_generator[:menus][4][:title]).to eq('Leave Categories')
      expect(@department_created_at_present.sidebar_menu_generator[:menus][4][:url]).to eq('/departments/settings/leave')
      expect(@department_created_at_present.sidebar_menu_generator[:menus][4][:icon]).to eq('fa-th-large')
      expect(@department_created_at_present.sidebar_menu_generator[:menus][4][:class]).to eq('leave')
      expect(@department_created_at_present.sidebar_menu_generator[:menus][4][:tooltip]).to eq('Leave Categories')
      expect(@department_created_at_present.sidebar_menu_generator[:menus][5][:title]).to eq('Expense Budget')
      expect(@department_created_at_present.sidebar_menu_generator[:menus][5][:url]).to eq('/departments/settings/budget')
      expect(@department_created_at_present.sidebar_menu_generator[:menus][5][:icon]).to eq('fa-th-large')
      expect(@department_created_at_present.sidebar_menu_generator[:menus][5][:class]).to eq('budget')
      expect(@department_created_at_present.sidebar_menu_generator[:menus][5][:tooltip]).to eq('Expense Budget')
      expect(@department_created_at_present.sidebar_menu_generator[:menus][6][:title]).to eq('Holiday Calender')
      expect(@department_created_at_present.sidebar_menu_generator[:menus][6][:url]).to eq('/departments/settings/attendance')
      expect(@department_created_at_present.sidebar_menu_generator[:menus][6][:icon]).to eq('fa-calendar-check-o')
      expect(@department_created_at_present.sidebar_menu_generator[:menus][6][:class]).to eq('attendance')
      expect(@department_created_at_present.sidebar_menu_generator[:menus][6][:tooltip]).to eq('Holiday Calender')
    end
  end

  describe 'instance department_slug' do
    it 'should return company_name_department_name' do
      expect(@department_created_at_present.department_slug).to eq(@department_created_at_present.company.name+"_"+@department_created_at_present.name)
    end
  end

  describe 'instance method active_employees' do
    context 'if date present' do
      it 'should return active employees of current department' do
        expect(@department_created_at_present.active_employees(date = 1.year.ago)).to eq(@department_created_at_present.employees.where('is_active = ? OR deactivate_date > ?', true, date))
      end
    end
    context 'if date not present' do
      it 'should return active employees of current department' do
        expect(@department_created_at_present.active_employees(date = nil)).to eq(@department_created_at_present.employees.where('is_active = ?', true))
      end
    end

  end

  # before(:each) do
  #   @company=FactoryGirl.create(:company)
  #   @department=FactoryGirl.create(:department, company_id: @company.id)
  #   @department_2 = FactoryGirl.create(:department, name: 'Syftet', company_id: @company.id, created_at: nil)
  #   @day_offs_1 = FactoryGirl.create(:attendance_day_off, department_id: @department.id, date: Date.today)
  # end
  #
  # describe 'instance method year' do
  #   context 'when created_at present' do
  #     it 'should return year of department created_at' do
  #       expect(@department.year).to eq(@department.created_at.strftime('%Y').to_i)
  #     end
  #   end
  #   context 'when created_at not present' do
  #     it 'should return year of department not created_at ' do
  #       expect(@department_2.year).to eq(Date.today.year)
  #     end
  #   end
  # end
  #
  # describe 'instance method events' do
  #   context 'when day_offs events present' do
  #     it 'should return day_offs events of current year' do
  #       expect(@department.events).to eq(@department.day_offs.collect { |day_off| {id: day_off.id, title: day_off.title, start: day_off.date.strftime('%Y-%m-%d'), allDayDefault: true} })
  #     end
  #     context 'when day_offs events not present' do
  #       it 'should returns day_offs events of current year empty' do
  #         expect(@department_2.events).to eq([])
  #       end
  #     end
  #   end
  # end
  #
  # describe 'sidebar_menu_generator' do
  #   it 'should return sidebar_menu_generator menus and their attributes' do
  #     expect(@department.sidebar_menu_generator[:title]).to eq('Department Settings')
  #     expect(@department.sidebar_menu_generator[:tooltip]).to eq('Department Settings')
  #     expect(@department.sidebar_menu_generator[:menus].size).to eq(6)
  #     expect(@department.sidebar_menu_generator[:menus][0][:title]).to eq('Information')
  #     expect(@department.sidebar_menu_generator[:menus][1][:title]).to eq('Employees')
  #     expect(@department.sidebar_menu_generator[:menus][2][:title]).to eq('Designation')
  #     expect(@department.sidebar_menu_generator[:menus][3][:title]).to eq('General')
  #     expect(@department.sidebar_menu_generator[:menus][4][:title]).to eq('Leave Categories')
  #     expect(@department.sidebar_menu_generator[:menus][5][:title]).to eq('Attendances')
  #   end
  #
  # end

end
