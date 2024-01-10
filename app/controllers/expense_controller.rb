class ExpenseController < ApplicationController
  before_filter :current_ability

  def dashboard
    year_begin = Date.today.beginning_of_year
    month_begin = start_of_prev_month
    start_date = year_begin < month_begin ? year_begin : month_begin
    end_date = Date.today.end_of_year

    initialize_basics(current_department, start_date, end_date)

    get_expense_summary(Date.today.beginning_of_month, Date.today.end_of_month)
    @compare_data_1 = get_compare_data(month_begin, month_begin.end_of_month)
    @compare_data_2 = @summary_data
    get_yearly_data(year_begin, end_date)
  end

  def summary
    start_date = params[:date].present? ? Date.new(params[:date][:year].to_i, params[:date][:month].to_i) : Date.today.beginning_of_month
    end_date = start_date.end_of_month
    initialize_basics(current_department, start_date, end_date)
    get_expense_summary(start_date, end_date)
  end

  def compare
    start_date_1 = start_of_prev_month
    start_date_2 = Date.today.beginning_of_month
    if params[:date].present?
      start_date_1 = Date.new(params[:date][:year_1].to_i, params[:date][:month_1].to_i)
      start_date_2 = Date.new(params[:date][:year_2].to_i, params[:date][:month_2].to_i)
    end
    end_date_1 = start_date_1.end_of_month
    end_date_2 = start_date_2.end_of_month
    @expenses = current_department.expenses_expenses.where(date: start_date_1..end_date_1, is_approved: true)
    @categories = current_department.expenses_categories.where(expense_category_id: nil)
    @compare_data_1 = get_compare_data(start_date_1, end_date_1)
    @expenses = current_department.expenses_expenses.where(date: start_date_2..end_date_2, is_approved: true)
    @compare_data_2 = get_compare_data(start_date_2, end_date_2)
  end

  def yearly
    start_date = params[:date].present? ? Date.new(params[:date][:year].to_i) : Date.today.beginning_of_year
    end_date = start_date.end_of_year
    initialize_basics(current_department, start_date, end_date)
    get_yearly_data(start_date, end_date)
  end

  private

  def initialize_basics(current_department, start_date, end_date)
    @expenses = current_department.expenses_expenses.where(date: start_date..end_date, is_approved: true)
    @categories = current_department.expenses_categories.where(expense_category_id: nil)
    @colors = get_random_colors(@categories.size)
  end

  def get_expense_summary(start_date, end_date)
    @summary_data = Expenses::Expense.dashboard_expenses(@expenses, @categories, start_date, end_date)
  end

  def get_compare_data(start_date, end_date)
    Expenses::Expense.dashboard_expenses(@expenses, @categories, start_date, end_date)
  end

  def get_yearly_data(start_date, end_date)
    @yearly_data = Expenses::Expense.dashboard_expenses(@expenses, @categories, start_date, end_date)
  end
end
