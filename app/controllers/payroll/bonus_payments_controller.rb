module Payroll
  class BonusPaymentsController < BaseController
    before_filter :current_ability
    before_action :set_bonus_payment, only: [:show, :edit, :update, :destroy]

    def index
      @start_date = params[:date].present? ? Date.new(params[:date][:year].to_i) : Date.today.beginning_of_year
      @end_date = @start_date.end_of_year

      if params[:employee_id].present?
        @employee = current_department.employees.find_by_id(params[:employee_id])
        @bonuses = @employee.bonus_payments.where(date: @start_date..@end_date).order(date: :desc)
      else
        @bonuses = current_department.bonus_payments.where(date: @start_date..@end_date).order(date: :desc)
      end
      respond_to do |format|
        format.js
        format.html
        format.pdf do
          render pdf: 'Bonus Payment Report', layout: 'pdf', template: 'payroll/bonus_payments/bonus_payments_report_pdf.html.erb', encoding: 'utf-8'
        end
        format.xls do
          render xls: 'Bonus Payment Report', layout: 'excel', template: 'payroll/bonus_payments/bonus_payments_report_pdf.html.erb', encoding: 'utf-8'
        end
        format.docx do
          render docx: 'Bonus Payment Report', layout: 'document', template: 'payroll/bonus_payments/bonus_payments_report_pdf.html.erb', encoding: 'utf-8'
        end
      end
    end

    def show
      respond_to do |format|
        format.js
      end
    end

    def new
      @employee = employee(params[:employee_id])
      @bonus_category = bonus_category(params[:bonus_category_id])
      if @employee.basic_salary.present?
        amount = @bonus_category.is_amount ? @bonus_category.amount : @employee.basic_salary * ( @bonus_category.amount / 100 )
        @bonus_payment = Payroll::BonusPayment.new(reason: @bonus_category.name, message: @bonus_category.message, amount: amount, department_id: params[:department_id], employee_id: @employee.id)
      end
      respond_to do |format|
        format.js
      end
    end

    def create
      @bonus_payment = Payroll::BonusPayment.create(bonus_payment_params)
      @employee = @bonus_payment.employee
      @start_date = @bonus_payment.date.year
      respond_to do |format|
        format.html
        format.js
      end
    end

    def edit
      respond_to do |format|
        format.js
      end
    end

    def update
      @bonus_payment.update(bonus_payment_params)
      respond_to do |format|
        format.js
      end
    end

    def destroy
      if @bonus_payment.destroy
        respond_to do |format|
          format.js
        end
      end

    end

    private

    def set_bonus_payment
      @bonus_payment = Payroll::BonusPayment.find_by_id(params[:id])
    end

    def bonus_payment_params
      params.require(:payroll_bonus_payment).permit!
    end

    def bonus_category(bonus_category_id)
      current_department.bonus_categories.find_by_id(bonus_category_id)
    end

    def employee(employee_id)
      current_department.employees.find_by_id(employee_id)
    end
  end
end