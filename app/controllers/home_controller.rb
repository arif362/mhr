class HomeController < ApplicationController
  skip_before_filter :authenticate_employee!
  skip_load_and_authorize_resource
  layout 'dashboard'

  def index
    @contact_us = ContactUs.new
    @posts = Community::Post.limit(3).order(id: :desc)
    if current_employee.present?
      @company_modules = current_company.company_features
      @available_modules = @company_modules.present? ? Feature.where("id NOT IN (#{@company_modules.map(&:feature_id).join(',')})") : Feature.all
    end
    # emp = Employee.new(email: 'gmarifulislamarif@gmail.com')
    # NotificationMailer.company_welcome(emp).deliver_now
  end

  def submit_contact
    @contact_us = ContactUs.new(contact_params)
    if @contact_us.save
      ContactMailer.send_contact(@contact_us).deliver
      redirect_to root_path, notice: 'Your message has been successfully sent.'
    else
      render :index
    end
  end

  def email_subscribe
    @subscription = Subscription.find_by_email(params[:subscription][:email]) ? Subscription.new : Subscription.create(email: params[:subscription][:email])
    respond_to do |format|
      format.js
    end
  end

  def terms_and_conditions

  end

  def new

  end

  def community

  end

  def pricing

  end

  def take_a_tour

  end

  def email_template
    render layout: false
  end


  def feedback
    feedback = Feedback.new(feedback_params)
    @status = feedback.save
    respond_to do |format|
      format.js
      format.html {
        flash[:success] = 'Thank your kind feedback'
        redirect_to root_path
      }
    end
  end

  def employee
    @modules = Feature.all
  end

  def leave
    @modules = Feature.all
  end

  def attendance
    @modules = Feature.all
  end

  def payroll
    @modules = Feature.all
  end

  def provident_fund
    @modules = Feature.all
  end

  def expense
    @modules = Feature.all
  end

  def bank
    @modules = Feature.all
  end

  def contact_us
    @contact_us = ContactUs.new
  end

  def watch_video
    @module = params[:module]
    @video = AppSettings::MODULE_VIDEO[@module.to_sym]
  end

  private

  def subscribe_params
    params.require(:subscription).permit!

  end

  def contact_params
    params.require(:contact_us).permit!
  end

  def feedback_params
    params.require(:feedback).permit(:name, :email, :design, :response, :functional, :rate, :comments)
  end
end
