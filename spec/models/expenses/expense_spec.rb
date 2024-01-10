# == Schema Information
#
# Table name: expense_expenses
#
#  id                      :integer          not null, primary key
#  description             :text(65535)
#  expense_category_id     :integer
#  expense_sub_category_id :integer
#  amount                  :float(24)
#  department_id           :integer
#  date                    :date
#  is_approved             :boolean          default(FALSE)
#  created_by_id           :integer
#  approved_by_id          :integer
#  received_by             :string(255)
#  attachment              :string(255)
#  payment_method          :string(255)
#  status                  :string(255)      default("pending")
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  voucher_number          :text(65535)
#

require 'rails_helper'

RSpec.describe Expenses::Expense, type: :model do
  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id: @company.id)
    @employee = FactoryGirl.create(:employee, role: Employee::ROLE[:admin], department_id: @department.id)
    @expenses_category = FactoryGirl.create(:expenses_category, department_id: @department.id)
    @expenses_expense = FactoryGirl.create(:expenses_expense, department_id: @department.id, expense_category_id: @expenses_category.id, expense_sub_category_id: @expenses_category.id, created_by_id: @employee.id, approved_by_id: @employee.id)
  end

  # describe 'class method # get_expense_report' do
  #   categories = Expenses::Category.all_expense_categories(@department)
  #   start_date = Date.today.beginning_of_year
  #   end_date = start_date.end_of_year
  #   context 'if category_id present' do
  #     it 'should return expense report' do
  #       expect(Expenses::Expense.get_expense_report(categories, @department, start_date, end_date, is_monthly=false, category_id = @expenses_category.id))
  #     end
  #   end
  #
  # end
end
