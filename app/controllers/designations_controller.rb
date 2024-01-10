class DesignationsController < ApplicationController
  before_filter :current_ability
  before_action :set_designation, only: [:show, :edit, :update, :destroy]

  def show
    respond_to do |format|
      format.js
    end
  end

  def new
    @designation = params[:department].present? ? Designation.new(department_id: params[:department]) : Designation.new

    respond_to do |format|
      format.html { }
      format.js {}
    end
  end

  def create

    department = params[:designation][:department_id].present? ? Department.find(params[:designation][:department_id]) : current_department

    @designation = department.designations.build(designation_params)


    respond_to do |format|
      if @designation.save
        format.html {redirect_to :back, notice: "Designation has been created successfully"}
        format.js
        format.json { render json: @designation }
      else
        format.html {render :new, notice: "Designation couldn't be created"}
        format.js
        format.json { render json: @designation.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def update
    respond_to do |format|
      if @designation.update(designation_params)
        format.html { redirect_to @designation, notice: 'Designation has been updated successfully'}
        format.json { render @designation, status: :ok}
        format.js
      else
        format.html { render :new, notice: "Designation couldn't be updated"}
        format.json { render @designation.errors, status: :unprocessable_entity}
        format.js
      end

    end
  end

  def destroy
    respond_to do |format|
      if @designation.destroy
        format.html { redirect_to :back, notice: 'Designation has been deleted successfully'}
        format.json { status :no_content}
        format.js
      else
        format.html { redirect_to :back, notice: "Designation couldn't be deleted"}
        format.json { status :internal_server_error}
        format.js
      end
    end
  end

  private
  def set_designation
    @designation = Designation.find_by_id(params[:id])
  end

  def designation_params
    params.require(:designation).permit!
  end
end
