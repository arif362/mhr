# == Schema Information
#
# Table name: expense_categories
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  description         :text(65535)
#  department_id       :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  expense_category_id :integer
#

require 'rails_helper'

RSpec.describe Expenses::Category, type: :model do

  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id: @company.id)
    @employee = FactoryGirl.create(:employee, role: Employee::ROLE[:admin], department_id: @department.id)
    @expenses_category = FactoryGirl.create(:expenses_category, department_id: @department.id)
    @expenses_budgets = FactoryGirl.create(:budget, company_id: @company.id, department_id: @department.id, category_id: @expenses_category.id)
  end

  describe 'class method#all_expense_categories' do
    it 'should return all expense categories of current department' do
      expect(Expenses::Category.all_expense_categories(@department)).to eq(@department.expenses_categories.where(expense_category_id: nil))
    end
  end

  describe 'class method#sub_categories_from_category' do
    it 'should return all sub_categories_from_category of current department' do
      expect(Expenses::Category.sub_categories_from_category(@expenses_category.id)).to eq(@department.expenses_categories.where(expense_category_id: @expenses_category.id))
    end
  end

  describe 'instance method # yearly_budget' do
    it 'should return yearly_budget of expenses' do
      expect(@expenses_category.yearly_budget(year = Date.today.year)).to eq(@expenses_category.expenses_budgets.where(year: Date.today.year).sum(:amount))
    end
  end

  describe 'instance method # monthly_budget' do
    it 'should return monthly_budget of expenses' do
      expect(@expenses_category.monthly_budget(year = Date.today.year)).to eq((0/ 12).round(2))
    end
  end

end
