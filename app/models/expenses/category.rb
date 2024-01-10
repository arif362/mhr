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

module Expenses
  class Category < Base
    belongs_to :department
    belongs_to :expense_category, :class_name => 'Expenses::Category', foreign_key: :expense_category_id

    has_many :expense_sub_categories, :class_name => 'Expenses::Category', foreign_key: :expense_category_id, dependent: :destroy
    has_many :expenses, :class_name => 'Expenses::Expense', foreign_key: :expense_category_id, dependent: :destroy
    has_many :sub_expenses, :class_name => 'Expenses::Expense', foreign_key: :expense_sub_category_id, dependent: :destroy
    has_many :expenses_budgets, :class_name => 'Expenses::Budget', dependent: :destroy

    validates_presence_of :name
    validates_uniqueness_of :name, scope: :department_id

    def self.all_expense_categories(current_department)
      current_department.expenses_categories.where(expense_category_id: nil)
    end

    def self.sub_categories_from_category(category_id)
      where(expense_category_id: category_id)
    end

    def yearly_budget(year = nil)
      year = year || Date.today.year
      expenses_budgets.where(year: year).sum(:amount) || 0
    end

    def monthly_budget(year = nil)
      year = year || Date.today.year
      budget_amount = yearly_budget(year)
      (budget_amount / 12).round(2)
    end
  end
end

