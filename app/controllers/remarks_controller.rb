class RemarksController < ApplicationController
  before_filter :current_ability

  # def index
  #   if params[:remarkable_type].count('::') > 0
  #     klass = params[:remarkable_type].split('::').inject(Object) {|o,c| o.const_get c}
  #   else
  #     klass = params[:remarkable_type].constantize
  #   end
  #   @remarkable_object = klass.find_by_id(params[:remarkable_id])
  #   @remarks = @remarkable_object.remarks
  #   @new_remark = Remark.new
  # end

  def new
    @remark = Remark.new
    if params[:remarkable_type].count('::') > 0
      klass = params[:remarkable_type].split('::').inject(Object) {|o,c| o.const_get c}
    else
      klass = params[:remarkable_type].constantize
    end
    @remarkable_object = klass.find_by_id(params[:remarkable_object])
    @remarks = @remarkable_object.remarks
  end

  def create
    if params[:remarkable_type].count('::') > 0
      klass = params[:remarkable_type].split('::').inject(Object) {|o,c| o.const_get c}
    else
      klass = params[:remarkable_type].constantize
    end
    @remarkable_object = klass.find_by_id(params[:remarkable_object])
    @remark = @remarkable_object.remarks.build(remark_params)
    @remark.remarked_by_id = current_employee.id
    if @remarkable_object.created_by_id == current_employee.id
      @remark.is_admin = false
    end
    respond_to do |format|
      if @remark.save
        unless @remarkable_object.approved_by.present?
          @remarkable_object.update_attributes(approved_by_id: current_employee.id, status: AppSettings::REMARK_STATUS[:remarked])
        end
        format.html {redirect_to expenses_expenses_path, notice: "Remark successfully created."}
      else
        format.html {redirect_to expenses_expenses_path, notice: "Error occured."}
      end
    end
  end

  private
  def remark_params
    params.require(:remark).permit!
  end
end
