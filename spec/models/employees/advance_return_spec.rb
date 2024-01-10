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

RSpec.describe Employees::AdvanceReturn, type: :model do
  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id:@company.id)
    @employee = FactoryGirl.create(:employee, role: Employee::ROLE[:admin], department_id:@department.id)
    @salary = FactoryGirl.create(:payroll_salary, department_id:@department.id, employee_id:@employee.id)
    @advance = FactoryGirl.create(:employees_advance, department_id:@department.id, employee_id:@employee.id)
    @advance_return = FactoryGirl.create(:employees_advance_return, employee_id:@employee.id, department_id:@department.id, salary_id:@salary.id, advance_id:@advance.id)
  end

  describe 'class method #incomplete_advance_returns' do
    context 'if employee_id present' do
      it 'should return incomplete_advance' do
        expect(Employees::AdvanceReturn.incomplete_advance_returns(@department, employee_id = @employee.id)).to eq([@advance_return])
      end
    end
    context 'if employee_id not present' do
      it 'should return incomplete_advance' do
        expect(Employees::AdvanceReturn.incomplete_advance_returns(@department, employee_id = nil)).to eq([@advance_return])
      end
    end
  end


end
