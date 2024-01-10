class Employees::PasswordsController < Devise::PasswordsController
  layout 'sessions'

  # GET /resource/password/new
  def new
    super
    respond_to do |format|
      format.js {}
    end
  end

  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?
    respond_to do |format|
      if successfully_sent?(resource)
        format.html { redirect_to new_employee_session_path, notice: "Successfully reset password. Please check your mail" }
        format.json { render json: {message: 'reset password'}, status: :ok, notice: "Successfully reset password. Please check your mail" }
      else
        format.html { redirect_to :back, notice: "There is error reseting password" }
        format.json { render json: resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    super
  end

  # PUT /resource/password
  def update
    super
  end

  protected

  def after_resetting_password_path_for(resource)
    super(resource)
  end

  # The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(resource_name)
    super(resource_name)
  end
end
