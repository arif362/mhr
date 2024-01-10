module Expenses
  class ExpensesController < BaseController
    before_filter :current_ability
    before_action :set_expense, only: [:show, :edit, :update, :destroy, :approve_reject]

    def index
      @start_date = Date.today.beginning_of_month
      @end_date = Date.today
      if params[:daterange].present?
        date_range = params[:daterange].split('To')
        @start_date = format_string_date(date_range.first)
        @end_date = format_string_date(date_range.last)
      end
      if params[:q].present? && params[:q] != 'All'
        @heading = params[:q]
        @expenses = current_department.expenses_expenses.where(status: params[:q], date: @start_date..@end_date).order(date: :asc)
      else
        @heading = 'All'
        @expenses = current_department.expenses_expenses.where(date: @start_date..@end_date).order(date: :asc)
      end
      respond_to do |format|
        format.html
        format.js
        format.xls do
          render xls: 'Expenses', layout: 'excel', template: 'expenses/expenses/expenses_xls_docx.html.erb', encoding: 'utf-8'
        end
        format.pdf do
          render pdf: 'Expenses', layout: 'pdf', template: 'expenses/expenses/expenses_pdf.html.erb', encoding: 'utf-8'
        end
        format.docx do
          render docx: 'Expenses', layout: 'document', template: 'expenses/expenses/expenses_xls_docx.html.erb', encoding: 'utf-8'
        end
      end
    end

    def attachment_view
      uploaded_attachment = Expenses::Expense.find_by_id(params[:id]).attachment
      send_file uploaded_attachment.path,
                :filename => uploaded_attachment,
                :type => uploaded_attachment,
                :disposition => 'attachment'
    end

    def show
    end

    def new
      @expense = Expenses::Expense.new
      @categories = current_department.expenses_categories.where(expense_category_id: nil)
      respond_to do |format|
        format.js
        format.html
      end
    end

    def create
      @expense = current_department.expenses_expenses.build(expense_params)
      @expense.created_by = current_employee
      respond_to do |format|
        if @expense.save
          format.html { redirect_to expenses_expenses_path, notice: "Expense successfully created." }
          format.js
          format.json
        else
          format.html { redirect_to expenses_expenses_path, notice: "Expense couldn't be created." }
          format.js
          format.json
        end
      end
    end

    def edit
      @categories = current_department.expenses_categories.where(expense_category_id: nil)
      if @expense.expense_category.present?
        @sub_categories = @expense.expense_category.expense_sub_categories
      end
      respond_to do |format|
        format.js
      end
    end

    def update
      respond_to do |format|
        if @expense.update(expense_params)
          format.html { redirect_to expenses_expenses_path, notice: "Expense successfully updated." }
          format.js
          format.json
        else
          format.html { redirect_to expenses_expenses_path, notice: "Expense couldn't be updated." }
          format.js
          format.json
        end
      end
    end

    def destroy
      respond_to do |format|
        @expense.destroy
        format.html { redirect_to expenses_expenses_path, notice: "Expense successfully deleted." }
      end
    end

    def approve_reject
      if params[:is_approved].present? && params[:is_approved] == 'yes'
        @expense.update_attributes(is_approved: true, status: AppSettings::STATUS[:approved], approved_by_id: current_employee.id)
      else
        @expense.update_attributes(is_approved: false, status: AppSettings::STATUS[:rejected], approved_by_id: current_employee.id)
      end
      respond_to do |format|
        format.html { redirect_to expenses_expenses_path, notice: "Expense status successfully changed." }
      end
    end

    def report
      @start_date = Date.today.beginning_of_year
      if params[:date].present?
        @start_date = Date.new(params[:date][:year].to_i, 1, 1)
      end
      @end_date = @start_date.end_of_year
      @expense_categories = Expenses::Category.all_expense_categories(current_department)
      @expense_report = Expenses::Expense.get_expense_report(@expense_categories, current_department, @start_date, @end_date, false)
      respond_to do |format|
        format.html
        format.xls do
          render xls: 'Expense Yearly Report', layout: 'excel', template: 'expenses/expenses/report_xls_docx.html.erb', encoding: 'utf-8'
        end
        format.pdf do
          render pdf: 'Expense Yearly Report', layout: 'pdf', orientation: 'Landscape', template: 'expenses/expenses/report_pdf.html.erb', encoding: 'utf-8'
        end
        format.docx do
          render docx: 'Expense Yearly Report', layout: 'document', template: 'expenses/expenses/report_xls_docx.html.erb', encoding: 'utf-8'
        end
      end
    end

    def monthly_report
      @start_date = Date.today.beginning_of_month
      if params[:date].present?
        @start_date = Date.new(params[:date][:year].to_i, params[:date][:month].to_i)
      end
      @end_date = @start_date.end_of_month
      @expense_categories = Expenses::Category.all_expense_categories(current_department)
      @expense_report = Expenses::Expense.get_expense_report(@expense_categories, current_department, @start_date, @end_date, true)
      respond_to do |format|
        format.html
        format.xls do
          render xls: 'Expense Monthly Report', layout: 'excel', template: 'expenses/expenses/monthly_report_xls_docx.html.erb', encoding: 'utf-8'
        end
        format.pdf do
          render pdf: 'Expense Monthly Report', layout: 'pdf', orientation: 'Landscape', template: 'expenses/expenses/monthly_report_pdf.html.erb', encoding: 'utf-8'
        end
        format.docx do
          render docx: 'Expense Monthly Report', layout: 'document', template: 'expenses/expenses/monthly_report_xls_docx.html.erb', encoding: 'utf-8'
        end
      end
    end

    def category_wise_report
      @start_date = Date.today.beginning_of_year
      if params[:date].present?
        @start_date = Date.new(params[:date][:year].to_i, 1, 1)
      end
      @end_date = @start_date.end_of_year
      @expense_categories = Expenses::Category.all_expense_categories(current_department)
      @expense_category = params[:category_id].present? ? Expenses::Category.find_by_id(params[:category_id]) : @expense_categories.first
      if @expense_category.present?
        @expense_sub_categories = @expense_category.expense_sub_categories
        @expense_report = Expenses::Expense.get_expense_report(@expense_sub_categories, current_department, @start_date, @end_date, false, @expense_category.id)
      else
        @expense_sub_categories = []
        @expense_report = []
      end

      respond_to do |format|
        format.html
        format.xls do
          render xls: 'Expense Sub Category Report', layout: 'excel', template: 'expenses/expenses/category_wise_report_xls_docx.html.erb', encoding: 'utf-8'
        end
        format.pdf do
          render pdf: 'Expense Sub Category Report', layout: 'pdf', orientation: 'Landscape', template: 'expenses/expenses/category_wise_report_pdf.html.erb', encoding: 'utf-8'
        end
        format.docx do
          render docx: 'Expense Sub Category Report', layout: 'document', template: 'expenses/expenses/category_wise_report_xls_docx.html.erb', encoding: 'utf-8'
        end
      end
    end

    def report_breakdown
      @start_date = Date.today.beginning_of_year
      @end_date = @start_date.end_of_year
      if params[:day] && params[:month].present? && params[:year].present?
        @start_date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
        @end_date = @start_date
      elsif params[:month].present? && params[:year].present?
        @start_date = Date.new(params[:year].to_i, params[:month].to_i, 1)
        @end_date = @start_date.end_of_month
      elsif params[:year].present?
        @start_date = Date.new(params[:year].to_i, 1, 1)
        @end_date = @start_date.end_of_year
      end
      if params[:category_id].present?
        @expense_category = Expenses::Category.find_by_id(params[:category_id])
        @expenses = current_department.expenses_expenses.where(date: @start_date..@end_date, expense_category_id: params[:category_id], is_approved: true)
      elsif params[:sub_category_id].present?
        @expense_sub_category = Expenses::Category.find_by_id(params[:sub_category_id])
        @expenses = current_department.expenses_expenses.where(date: @start_date..@end_date, expense_sub_category_id: params[:sub_category_id], is_approved: true)
      else
        @expenses = current_department.expenses_expenses.where(date: @start_date..@end_date, is_approved: true)
      end
      respond_to do |format|
        format.html
        format.js
        format.xls do
          render xls: 'Expense Report Breakdown', layout: 'excel', template: 'expenses/expenses/report_breakdown_xls_docx.html.erb', encoding: 'utf-8'
        end
        format.pdf do
          render pdf: 'Expense Report Breakdown', layout: 'pdf', template: 'expenses/expenses/report_breakdown_pdf.html.erb', encoding: 'utf-8'
        end
        format.docx do
          render docx: 'Expense Report Breakdown', layout: 'document', template: 'expenses/expenses/report_breakdown_xls_docx.html.erb', encoding: 'utf-8'
        end
      end
    end

    private
    def set_expense
      @expense = Expenses::Expense.find_by_id(params[:id])
    end

    def expense_params
      params.require(:expenses_expense).permit!
    end
  end
end

