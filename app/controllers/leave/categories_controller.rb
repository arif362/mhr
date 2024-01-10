module Leave
  class CategoriesController < Leave::BaseController
    before_filter :current_ability
    before_action :set_leave_category, only: [:show, :edit, :update, :destroy, :activate, :deactivate]

    def new
      @leave_category = Leave::Category.new
      respond_to do |format|
        format.js
      end
    end

    def show
    end

    def edit
    end

    def create
      @department = Department.find(params[:department_id]) || current_department
      @leave_category = @department.leave_categories.build(leave_category_params)
      @leave_category_hash = Leave::CategoryYear.hashed_item(@leave_category, nil, nil)
      respond_to do |format|
        @leave_category.save
        format.js
      end
    end

    def update
      respond_to do |format|
        @leave_category.update(leave_category_params)
        format.js
      end
    end

    def destroy
      @leave_category.destroy
      respond_to do |format|
        format.js
      end
    end

    def activate
      respond_to do |format|
        @leave_category.update(is_active: true)
        format.js
      end
    end

    def deactivate
      respond_to do |format|
        @leave_category.update(is_active: false)
        format.js
      end
    end

    private
    def set_leave_category
      @leave_category = Leave::Category.find(params[:id])
    end

    def leave_category_params
      params.require(:leave_category).permit!
    end
  end
end