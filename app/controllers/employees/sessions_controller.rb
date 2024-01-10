class Employees::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]
  before_action :complete_profile,  except: ['destroy']
  layout "sessions"
  #GET /resource/sign_in
  def new
    super
  end

  #POST /resource/sign_in
  def create
    resource = Employee.find_for_database_authentication(email: params[:employee][:email])
    respond_to do |format|
      if resource.present? && (resource.confirmation_token.present? || resource.invitation_token.present?)
        flash[:danger] = 'You have to confirm your email address before continuing.'
        format.js
        format.html{ redirect_to :back }

      elsif resource.present? && !resource.is_active
        sign_out :employee
        flash[:danger] = 'Your account has been deactivated. Please contact with administrator.'
        format.js
        format.html { redirect_to :back  }

      elsif resource.present? && !resource.valid_password?(params[:employee][:password])
        flash[:danger] = 'Invalid email or password.'
        format.js
        format.html { redirect_to :back}

      elsif resource.present? && resource.valid_password?(params[:employee][:password])
        sign_in :employee, resource
        flash[:success] = 'Signed in successfully.'
        format.js
        format.html { redirect_to after_sign_in_path_for(resource) }

      else
        flash[:danger] = 'Invalid email or password.'
        format.js
        format.html { redirect_to :back }
      end

    end

  end

  #DELETE /resource/sign_out
  def destroy
    super
  end

  protected

  #If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    #devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    devise_parameter_sanitizer.permit(:sign_in) do |u|
      u.permit(:email, :password)
    end
  end
end
