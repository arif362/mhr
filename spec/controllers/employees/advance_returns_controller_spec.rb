# == Schema Information
#
# Table name: employees_advance_returns
#
#  id            :integer          not null, primary key
#  date          :date
#  amount        :float(24)
#  employee_id   :integer
#  department_id :integer
#  advance_id    :integer
#  salary_id     :integer
#  return_from   :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Employees::AdvanceReturnsController, type: :controller do

  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id:@company.id)
    @employee = FactoryGirl.create(:employee, role:Employee::ROLE[:admin], department_id:@department.id)
    @advance = FactoryGirl.create(:employees_advance, employee_id:@employee.id, department_id:@department.id)
    @employees_advance_return = FactoryGirl.create(:employees_advance_return, employee_id:@employee.id, department_id:@department.id,advance_id:@advance.id)
    session[:department_id] = @department.id
    sign_in(@employee)
  end

  describe 'get # new' do
    it 'should request to new action' do
      xhr :get, :new, format: :js
      expect(response).to be_success
    end
  end

  describe 'post#create' do
    context 'if @advance_return.save' do
      it 'should request to create action' do
        post :create, employees_advance_return:{employee_id:@employee.id, department_id:@department.id,advance_id:@advance.id, date:Date.today,amount:500}
        expect(response).to redirect_to(employees_advances_path)
      end
    end
    context 'if @advance_return not save' do
      it 'should request to create action' do
        post :create, employees_advance_return:{employee_id:@employee.id, department_id:@department.id,advance_id:@advance.id}
        expect(response).to redirect_to(employees_advances_path)
      end
    end
  end

end
