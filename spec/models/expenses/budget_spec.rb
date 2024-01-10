# == Schema Information
#
# Table name: expense_budgets
#
#  id            :integer          not null, primary key
#  category_id   :integer
#  department_id :integer
#  company_id    :integer
#  year          :integer
#  amount        :float(24)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Expenses::Budget, type: :model do

  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id: @company.id)
    @employee = FactoryGirl.create(:employee, department_id: @department.id)
    @expenses_category = FactoryGirl.create(:expenses_category, department_id: @department.id)
    @budget = FactoryGirl.create(:budget, company_id: @company.id, department_id: @department.id, category_id: @expenses_category.id)
  end

  describe 'class method # all_expense_categories' do
    it 'should return all expenses_categories of current department' do
      expect(Expenses::Budget.all_expense_categories(@department)).to eq(@department.expenses_categories.where(expense_category_id: nil))
    end
  end

  describe 'class method # sub_categories_from_category' do
    it 'should return all sub_categories_from_category of current department' do
      expect(Expenses::Budget.sub_categories_from_category(1)).to eq(@department.expenses_categories.where(expense_category_id: 1))
    end
  end

end
