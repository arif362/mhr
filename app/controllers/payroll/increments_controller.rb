module Payroll
  class IncrementsController < BaseController
    before_filter :current_ability
    before_action :set_increment, only:[:show, :update, :edit, :destroy, :accept]
    def index
      @increments = current_department.payroll_increments.order(id: :desc)
    end

    def show
      respond_to do |format|
        format.js
      end
    end

    # def new
    #   @increment = Payroll::Increment.new
    #   respond_to do |format|
    #     format.js
    #   end
    # end

    def create
      @increment = current_department.payroll_increments.build(increment_params)
      @increment.present_basic = params[:payroll_increment][:previous_basic].to_i + params[:payroll_increment][:increment_amount].to_i
      @increment.is_active = false
      respond_to do |format|
        if @increment.save
          format.js
          format.html {redirect_to payroll_increments_path, notice: 'Successfully Created'}
        else
          format.js
          format.html {render @increment.errors, status: :unprocessable_entity }
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
        @increment.update(increment_params)
        format.js
      end
    end

    def destroy
      @increment.destroy
      @increments = current_department.payroll_increments
      respond_to do |format|
        format.js
      end
    end

    # def employee_increment
    #   @increment = current_department.payroll_increments.where(emplyee_id: params[:employee_id])
    #   respond_to do |format|
    #     format.js
    #   end
    # end

    def accept
      employee = @cur_department.employees.find_by_id(@increment.employee_id)
      employee.change_employee_salary(@increment)
      @increments = current_department.payroll_increments
      respond_to do |format|
        format.js
      end
    end

    private
    def set_increment
      @increment = current_department.payroll_increments.find(params[:id])
    end

    def increment_params
      params.require(:payroll_increment).permit!
    end
  end
end