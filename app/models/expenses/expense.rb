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

module Expenses
  class Expense < Base
    mount_uploader :attachment, FileUploader
    belongs_to :department
    belongs_to :expense_category, :class_name => 'Expenses::Category', foreign_key: :expense_category_id
    belongs_to :expense_sub_category, :class_name => 'Expenses::Category', foreign_key: :expense_sub_category_id
    belongs_to :created_by, :class_name => 'Employee', foreign_key: :created_by_id
    belongs_to :approved_by, :class_name => 'Employee', foreign_key: :approved_by_id
    has_many :remarks, as: :remarkable, dependent: :destroy
    validates_presence_of :amount, :date, :expense_category_id, :created_by_id, :status

    def self.get_expense_report(categories, current_department, start_date, end_date, is_monthly, category_id = nil)
      if category_id.present?
        expenses = current_department.expenses_expenses.where(date: start_date..end_date, expense_category_id: category_id, is_approved: true)
      else
        expenses = current_department.expenses_expenses.where(date: start_date..end_date, is_approved: true)
      end
      start_number = 1
      end_number = 12
      if is_monthly
        start_number = start_date.day
        end_number = end_date.day
      end
      expense_report = initialize_expense_report(categories, start_number, end_number)
      expense_report = get_updated_expense_report(expenses, expense_report, category_id, is_monthly)
      if is_monthly && !category_id.present?
        categories.each do |category|
          sub_categories = category.expense_sub_categories
          sub_expenses = expenses.where(expense_category_id: category.id)
          sub_expense_report = initialize_expense_report(sub_categories, start_number, end_number)
          expense_report[category.id][:sub_category_report] = get_updated_expense_report(sub_expenses, sub_expense_report, category.id, is_monthly)
        end
      end
      expense_report
    end

    def self.initialize_expense_report(categories, start_number, end_number)
      expense_report = {}
      expense_report[:month_total] = {
          amount: 0
      }
      (start_number..end_number).each do |number|
        expense_report[:month_total][number] = 0
      end
      categories.each do |category|
        expense_report[category.id] = {
            category: category,
            total_amount: 0,
            sub_category_report: ''
        }
        (start_number..end_number).each do |number|
          month_report = {
              amount: 0
          }
          expense_report[category.id][number] = month_report
        end
      end
      expense_report
    end

    def self.get_updated_expense_report(expenses, expense_report, category_id, is_month)
      expenses.each do |expense|
        month_num = is_month ? expense.date.day.to_i : expense.date.month.to_i
        if category_id.present?
          if expense.expense_sub_category_id.present? && expense_report[expense.expense_sub_category_id][month_num]
            expense_report[expense.expense_sub_category_id][month_num][:amount] += expense.amount
            expense_report[expense.expense_sub_category_id][:total_amount] += expense.amount
            expense_report[:month_total][month_num] += expense.amount
            expense_report[:month_total][:amount] += expense.amount
          end
        else
          if expense.expense_category_id.present? && expense_report[expense.expense_category_id][month_num]
            expense_report[expense.expense_category_id][month_num][:amount] += expense.amount
            expense_report[expense.expense_category_id][:total_amount] += expense.amount
            expense_report[:month_total][month_num] += expense.amount
            expense_report[:month_total][:amount] += expense.amount
          end
        end
      end
      expense_report
    end

    def self.get_sub_category_report(category, start_date, end_date)
      sub_categories = category.expense_sub_categories
      expenses = category.expenses.where(date: start_date..end_date, is_approved: true)
      expense_report = initialize_expense_report(sub_categories, 1, end_date.day)
      expense_report = get_updated_expense_report(expenses, expense_report, category.id, true)
      expense_report
    end

    def self.dashboard_expenses(expenses, categories, start_date, end_date)
      grouped_expenses = expenses.includes(:expense_category).where(date: start_date..end_date).group(:expense_category_id).select("expense_category_id, SUM(expense_expenses.amount) AS sum_amount").order('sum_amount desc')
      total = 0.0
      amounts = []
      budgets = []
      category_names = []
      i = 0
      categories.each do |category|
        category_names.push(category.name)
        budgets.push(start_date.month == end_date.month ? category.monthly_budget(start_date.year) : category.yearly_budget(start_date.year))
        cat_exp = grouped_expenses.where(expense_category_id: category.id)
        if cat_exp.present?
          amounts.push(cat_exp.first.sum_amount)
          total += cat_exp.first.sum_amount
        else
          amounts.push(0)
        end
      end
      {grouped_expenses: grouped_expenses, categories: category_names, amounts: amounts, budgets: budgets, total: total, start_date: start_date, end_date: end_date}
    end
  end
end

