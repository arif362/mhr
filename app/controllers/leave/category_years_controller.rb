module Leave
  class CategoryYearsController < BaseController
    before_filter :current_ability
    before_action :set_leave_category_year, only: [:edit, :update, :destroy]

    def new
      @department = Department.find_by_id(params[:department_id])
      @leave_category_year = @department.leave_category_years.new(leave_category_id: params[:leave_category_id])
      respond_to do |format|
        format.js
      end
    end

    def create
      @leave_category_year = Leave::CategoryYear.create(leave_category_year_params)
      @department = @leave_category_year.department
      @leave_category_hash = Leave::CategoryYear.hashed_item(@leave_category_year.leave_category, @leave_category_year.days, @leave_category_year)
      respond_to do |format|
        format.js
      end
    end

    def edit
      @department = @leave_category_year.department
      respond_to do |format|
        format.js
      end
    end

    def update
      if @leave_category_year.update(leave_category_year_params)
        @department = @leave_category_year.department
        @leave_category_hash = Leave::CategoryYear.hashed_item(@leave_category_year.leave_category, @leave_category_year.days, @leave_category_year)
        respond_to do |format|
          format.js
        end
      end
    end

    def destroy
      @department = Department.find_by_id(@leave_category_year.department_id)
      @leave_category_hash = Leave::CategoryYear.hashed_item(@leave_category_year.leave_category, nil, nil)
      if @leave_category_year.delete
        respond_to do |format|
          format.js
        end
      end
    end

    private

    def set_leave_category_year
      @leave_category_year = Leave::CategoryYear.find(params[:id])
    end

    def leave_category_year_params
      params.require(:leave_category_year).permit!
    end
  end
end
