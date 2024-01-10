module Employees
  class AdvancesController < ApplicationController
    before_filter :current_ability
    before_action :set_advance, only: [:show, :edit, :update, :destroy]

    def index
      start_date = params[:date].present? ? Date.new(params[:date][:year].to_i) : Date.today.beginning_of_year
      end_date = start_date.end_of_year
      @advances = Employees::Advance.search(current_department, start_date, end_date, params[:status], params[:employee])
      @employees = current_department.employees
      respond_to do |format|
        format.html
        format.js
        format.xls do
          render xls: 'Advance List', layout: 'excel', template: 'employees/advances/advance_list_xls_doc.html.erb', encoding: 'utf-8'
        end
        format.pdf do
          render pdf: 'Advance List', layout: 'pdf', template: 'employees/advances/advance_list_pdf.html.erb', encoding: 'utf-8'
        end
        format.docx do
          render docx: 'Advance List', layout: 'document', template: 'employees/advances/advance_list_xls_doc.html.erb', encoding: 'utf-8'
        end
      end
    end

    def show
      @balance = 0.0
      @advance_report = Employees::Advance.report(current_department, nil, @advance)
    end

    def new
      @advance = Employees::Advance.new
      respond_to do |format|
        format.js
      end
    end

    def create
      @advance = current_department.advances.build(advance_params)
      respond_to do |format|
        if @advance.save
          format.html {redirect_to employees_advances_path, notice: 'Advance has been created successfully'}
        else
          format.html {redirect_to employees_advances_path, notice: "Advance couldn't be created."}
        end
      end
    end

    def edit
      respond_to do |format|
        format.js
      end
    end

    def update
      respond_to do |format|
        if @advance.update(advance_params)
          format.html {redirect_to employees_advances_path, notice: 'Advance has been updated successfully.'}
        else
          format.html {redirect_to employees_advances_path, notice: "Advance couldn't be updated"}
        end
      end
    end

    def destroy
      respond_to do |format|
        if @advance.destroy
          format.html {redirect_to employees_advances_path, notice: 'Advance successfully deleted.'}
          format.js
        else
          format.html {redirect_to employees_advances_path, notice: 'Unable to delete advance, Please try again later.'}
          format.js
        end
      end
    end

    def history
      @balance = 0.0
      @employees = current_department.employees
      @advance_report = Employees::Advance.report(current_department, params[:employee_id])
      respond_to do |format|
        format.html
        format.xls do
          render xls: 'Advance History', layout: 'excel', template: 'employees/advances/history_xls_doc.html.erb', encoding: 'utf-8'
        end
        format.pdf do
          render pdf: 'Advance History', layout: 'pdf', template: 'employees/advances/history_pdf.html.erb', encoding: 'utf-8'
        end
        format.docx do
          render docx: 'Advance History', layout: 'document', template: 'employees/advances/history_xls_doc.html.erb', encoding: 'utf-8'
        end
      end
    end

    def employee_advances
      if params[:employee_id].present?
        @employee = Employee.find_by_id(params[:employee_id])
        @advances = @employee.advances.where(is_completed: false).includes(:advance_returns)
      end
    end

    private

    def advance_params
      params.require(:employees_advance).permit!
    end

    def set_advance
      @advance = current_department.advances.find(params[:id])
    end
  end
end