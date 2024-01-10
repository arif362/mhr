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

class Budget < ActiveRecord::Base
end

module Expenses
  class Budget < Base
    belongs_to :department
    belongs_to :company
    belongs_to :expenses_category, :class_name => 'Expenses::Category'
    validates_presence_of :amount

    def self.all_expense_categories(current_department)
      current_department.expenses_categories.where(expense_category_id: nil)
    end

    def self.sub_categories_from_category(category_id)
      where(category_id: category_id)
    end
  end
end
