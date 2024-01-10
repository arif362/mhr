# == Schema Information
#
# Table name: employees_advances
#
#  id             :integer          not null, primary key
#  employee_id    :integer
#  amount         :float(24)
#  is_paid        :boolean          default(FALSE)
#  purpose        :text(65535)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  department_id  :integer
#  is_deactivated :boolean          default(FALSE)
#  is_completed   :boolean          default(FALSE)
#  installment    :float(24)
#  return_policy  :string(255)
#  date           :date
#

require 'rails_helper'

RSpec.describe Employees::Advance, type: :model do

  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id: @company.id)
    @employee = FactoryGirl.create(:employee, department_id: @department.id)
  end

  describe 'class method#employees_take_advance' do
    context 'if advances present' do
      it 'should return employee advances' do
        @employees_advance = FactoryGirl.create(:employees_advance, department_id: @department.id, employee_id: @employee.id)
        expect(Employees::Advance.employees_take_advance(@department, advances = nil)).to eq([[@employees_advance.employee.full_name, @employees_advance.employee_id]])
      end
    end
    context 'if advances not present' do
      it 'should return incomplete_advances of current department' do
        expect(Employees::Advance.employees_take_advance(@department, advances = nil)).to eq(@department.advances.where(is_completed: false))
      end
    end
  end

  describe 'instance method#installment_amount' do
    context 'if installment present' do
      it 'should return installment_amount' do
        @employees_advance = FactoryGirl.create(:employees_advance, installment: 2, department_id: @department.id, employee_id: @employee.id)
        expect(@employees_advance.installment_amount).to eq(5.0)
      end
    end
    context 'if installment not present' do
      it 'should return installment_amount' do
        @employees_advance = FactoryGirl.create(:employees_advance, department_id: @department.id, employee_id: @employee.id)
        expect(@employees_advance.installment_amount).to eq(0.0)
      end
    end
  end

  describe 'class method#not_completed' do
    context 'if advances not presents' do
      it 'should return incomplete_advances of current department' do
        expect(Employees::Advance.not_completed(@department, advances = nil)).to eq(@department.advances.where(is_completed: false))
      end
    end
  end

  describe 'instance method#return' do
    it 'should return all advances' do
      @employees_advance = FactoryGirl.create(:employees_advance, department_id: @department.id, employee_id: @employee.id)
      @employees_advance_return = FactoryGirl.create(:employees_advance_return, employee_id: @employee.id, department_id: @department.id, advance_id: @employees_advance.id)
      expect(@employees_advance.returned).to eq(500)
    end
  end

  describe 'class method#search' do
    start_date = Date.today.beginning_of_year
    end_date = Date.today.end_of_year
    context 'If employee_id present' do
      context 'when employee_id present but status not present' do
        it 'should return advances' do
          expect(Employees::Advance.search(@department, start_date, end_date, status = nil, employee_id = @employee.id)).to eq(@department.advances.where(date: start_date..end_date, is_completed: false, employee_id: @employee.id).includes(:employee).order(id: :desc))
        end
      end
      context 'when employee_id present and status == Employees::AdvanceReturn::STATUS[:all]' do
        it 'should return advances' do
          expect(Employees::Advance.search(@department, start_date, end_date, status = Employees::AdvanceReturn::STATUS[:all], employee_id = @employee.id)).to eq(@department.advances.where(date: start_date..end_date, employee_id: employee_id).includes(:employee).order(id: :desc))
        end
      end
      context 'when employee_id present and status == Employees::AdvanceReturn::STATUS[:completed]' do
        it 'should return advances' do
          expect(Employees::Advance.search(@department, start_date, end_date, status = Employees::AdvanceReturn::STATUS[:completed], employee_id = @employee.id)).to eq(@department.advances.where(date: start_date..end_date, is_completed: true, employee_id: employee_id).includes(:employee).order(id: :desc))
        end
      end
    end
    context 'if employee_id not present' do
      context 'when employee_id not present but status == Employees::AdvanceReturn::STATUS[:all]' do
        it 'should return advances' do
          expect(Employees::Advance.search(@department, start_date, end_date, status = Employees::AdvanceReturn::STATUS[:all], employee_id = nil)).to eq(@department.advances.where(date: start_date..end_date).includes(:employee).order(id: :desc))
        end
      end
      context 'when employee_id not present but status == Employees::AdvanceReturn::STATUS[:completed]' do
        it 'should return advances' do
          expect(Employees::Advance.search(@department, start_date, end_date, status = Employees::AdvanceReturn::STATUS[:completed], employee_id = nil)).to eq(@department.advances.where(date: start_date..end_date, is_completed: true).includes(:employee).order(id: :desc))
        end
      end
    end
    context 'when employee_id and status not present' do
      it 'should return advances' do
        expect(Employees::Advance.search(@department, start_date, end_date, status = nil, employee_id = nil)).to eq([])
        expect(Employees::Advance.search(@department, start_date, end_date, status = nil, employee_id = nil)).to eq(@department.advances.where(date: start_date..end_date, is_completed: false).includes(:employee).order(id: :desc))
      end
    end
  end

  describe 'class method # report' do
    context 'when advance present' do
      it 'should assign new advance report' do
        new_advance = FactoryGirl.create(:employees_advance, department_id: @department.id, employee_id: @employee.id)
        expect(Employees::Advance.report(@department, employee_id = nil, advance = new_advance)).to eq([{date: new_advance.date, employee: new_advance.employee, given: new_advance.amount, return: '-'}])
      end
    end

    context 'when advance not present' do
      it 'should return advances report of current department' do
        @employees_advance = FactoryGirl.create(:employees_advance, department_id: @department.id, employee_id: @employee.id)
        expect(Employees::Advance.report(@department, employee_id = nil, advance = nil)).to eq([{date: @employees_advance.date, employee: @employees_advance.employee, given: @employees_advance.amount, return: '-'}])
      end
      it 'should return advances_return report of current department' do
        @employees_advance_return = FactoryGirl.create(:employees_advance_return, employee_id: @employee.id, department_id: @department.id, advance_id: 123)
        expect(Employees::Advance.report(@department, employee_id = nil, advance = nil)).to eq([{date: @employees_advance_return.date, employee: @employees_advance_return.employee, given: '-', return: @employees_advance_return.amount}])
      end
    end
  end

  # describe 'class method # initial_balance' do
  #   it 'should return  return_amount - advance_amount' do
  #     expect(Employees::Advance.initial_balance(@department, date, employee_id = nil)).to eq(500-10)
  #   end
  # end

end
