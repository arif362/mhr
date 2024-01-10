module Employees
  class AdvanceReturnsController < ApplicationController
    before_filter :current_ability

    def new
      @advance_return = Employees::AdvanceReturn.new
      @employees = Employees::Advance.employees_take_advance(current_department)
      respond_to do |format|
        format.js
      end
    end

    def create
      @advance_return = current_department.advance_returns.build(advance_return_params)
      respond_to do |format|
        if @advance_return.save
          @advance = @advance_return.advance
          returned_amount = @advance.advance_returns.sum(:amount)
          if @advance.amount <= returned_amount
            @advance.update(is_completed: true)
          end
          format.html { redirect_to employees_advances_path, notice: 'Advance successfully returned.'}
        else
          format.html { redirect_to employees_advances_path, notice: 'Error: Advance not returned.'}
        end
      end
    end

    private

    def advance_return_params
      params.require(:employees_advance_return).permit!
    end
  end
end
