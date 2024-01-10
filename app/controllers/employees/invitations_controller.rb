class Employees::InvitationsController < Devise::InvitationsController

  def new
    @department_id = params[:department] || current_department.id
    @employee = Employee.new()
    respond_to do |format|
      format.js { }
    end
  end

  def create
    self.resource = invite_resource
    resource_invited = resource.errors.empty?

    yield resource if block_given?
    respond_to do |format|
      if resource_invited
        format.html {redirect_to :back, notice: "#{resource.email} email has been invited successfully"}
        format.json { render json: resource, status: :ok}
      else
        format.html {render resource.errors, notice: "#{resource.email} email couldn't be invited"}
        format.json { render json: resource.errors, status: :unprocessable_entity}
      end
    end
  end

  def edit
    super
  end

  def update
    super
  end
end
