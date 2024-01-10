class ApplicationController < ActionController::Base


  after_action :set_vary_header
  protect_from_forgery with: :exception
  before_filter :authenticate_employee!, :admin_check, :set_cache_buster
  helper_method :employee_role, :current_department, :todays_attendances, :current_currency,
                :current_active_employees, :errors_to_message_string, :flash_types, :current_permissions,
                :current_company, :resource, :resource_name, :devise_mapping, :is_available_module?, :current_namespace, :work_progress1
  before_action :complete_profile
  around_filter :set_time_zone
  add_flash_types :info, :success, :danger, :warning


  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html {
        redirect_to :back, :alert => exception.message
      }
      format.js { render :file => "shared/access_right_error.js.erb" }
    end
  end

  # Used for Converting errors object to string message
  def errors_to_message_string(errors)
    message_wrapper = "<ul class='devise-error-message'>"
    message = ''
    errors.each_with_index do |(key, error_message), index|
      field = (key.to_s == 'custom' || key.to_s == 'password_confirmation' || key.to_s == 'base') ? '' : key.to_s
      message += "<li> #{field.camelize} #{error_message} </li>"
    end
    (message_wrapper + message + '</ul>').html_safe
  end

  def admin_check

    controller = params[:controller].classify

    if current_employee.present? && controller.split("::").first == "ActiveAdmin"
      redirect_to '/', notice: "Log out as employee before you want to access admin login"

    elsif current_admin_user.present? && controller.split("::").first != "Admin"

      redirect_to admin_root_path, notice: "Please logout from admin panel before you want to access mhr" unless controller.split("::").first == "ActiveAdmin"

    end
  end


  # after sign in path override from devise
  def after_sign_in_path_for(resource)
    if resource.is_a?(AdminUser)
      stored_location_for(resource) || admin_dashboard_path
    else
      if resource.role == Employee::ROLE[:admin]
        if resource.next_path.present?
          resource.next_path
        else
          request.env['omniauth.origin'] || stored_location_for(resource) || root_path
        end
      else
        request.env['omniauth.origin'] || stored_location_for(resource) || employee_path(resource)
      end
    end
  end

  def before_sign_in_path_for(resource)

  end

  def employee_import_message_generator(hash, count)
    html = '<ul>'
    html << "<li> But there is a problem with the following #{ 'row'.pluralize(count) } of the file; </li>"
    hash.each do |hs|
      unless hs[:status]
        html << "<li> Row no # #{hs[:row]}, #{ hs[:message] }</li>"
      end
    end
    html << '</ul>'
  end


  # For getting employee role
  def employee_role(resource = current_employee)
    resource.role
  end


  # Getting
  def current_department
    department_id = 0
    if session[:department_id].present?
      department_id = session[:department_id]
    elsif current_employee.present? and current_employee.department_id.present?
      department_id = current_employee.department_id
    end
    @cur_department = Department.find_by_id(department_id)
  end

  def current_company
    current_department.company if current_department.present?
  end

  def current_active_employees
    current_department.employees.where('invitation_token IS NULL and is_active = true')
  end

  def current_currency
    current_department.setting.present? && current_department.setting.currency.present? ? current_department.setting.currency.upcase : 'bdt'.upcase
  end

  def format_string_date(str_date)
    new_date = Date.parse(str_date)
    new_date.strftime('%Y-%m-%d')
  end

  def todays_attendances(employee)
    employee.attendances.where(in_date: Date.today).order(id: :desc)
  end

  def permit_module(feature_module)
    company = current_department.company
    unless company.present? && company.features.find_by_name(feature_module.to_s)
      flash[:error] = 'This module is not enabled, Please goto settings and enabled this module'
      redirect_to root_path
    end
  end

  def flash_types
    ['info', 'success', 'danger', 'warning']
  end

  def current_department_active_employees(date)
    current_department.employees.where('is_active = ? OR deactivate_date > ?', true, date).where('invitation_token IS NULL')
  end

  def resource_name
    :employee
  end

  def resource
    @resource ||= Employee.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:employee]
  end

  def start_of_prev_month(date = Date.today)
    (date.beginning_of_month - 1.day).beginning_of_month
  end

  def get_random_colors(n)
    colors = []
    (1..n).each do
      colors.push("#" + ("%06x" % (rand * 0xffffff)))
    end
    colors
  end

  def get_random_data(n)
    progress = []
    (1..n).each do |n|
      progress.push("#{n+10}" )
    end
    progress
  end

  def get_employees_progress(employees, start_date, end_date)
    progress = []
    monthly_progress = []
    employees.each do |employee|
     single_progress = employee.progress_report(start_date, end_date)
     if single_progress.present?
       single_progress.each do |key, report|
        daily_progress = employee_work_progress(report)
        monthly_progress.push(daily_progress)
       end
       per_month_progress = (monthly_progress.sum/monthly_progress.count)
       per_month_progress = per_month_progress.round(2)
     end
     progress.push(per_month_progress )
    end
    progress
  end

  def employee_work_progress(tasks)
    total = tasks.count
    completed = 0
    tasks.each do |task|
      completed += 1 if task.is_complete
    end
    percentage = 0
    if completed > 0
      percentage = (completed.to_f/total.to_f) * 100
      percentage = percentage.round(2)
    end
    percentage
  end

  def is_available_module?(namespace = current_namespace)
    available_modules_name = current_employee.department.company.features.collect { |f| f.app_module }
    total_modules = available_modules_name + Ability::SETUP_MODULES
    total_modules.include?(namespace)
  end

  def current_namespace(controller = params[:controller])
    controller_name_segments = controller.split('/')
    controller_name_segments.pop
    controller_name_segments.join('/').camelize
  end

  def current_ability
    @current_ability ||= Ability.new(current_employee, current_namespace, params[:controller], params[:action])
    @current_ability.authorize! params[:action].to_sym, params[:controller].classify
  end


  private

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def complete_profile
    if employee_signed_in? && current_employee.next_path.present?
      flash[:error] = 'Please complete your registration process!'
      redirect_to current_employee.next_path
    end
  end

  def set_time_zone(&block)
    time_zone = current_department.setting.present? && current_department.setting.time_zone.present? ? current_department.setting.time_zone : 'Dhaka'
    Time.use_zone(time_zone, &block)
  rescue
    Time.use_zone('Dhaka', &block)
  end

  def check_department_settings
    setting = current_department.setting
    setting.open_time.present? && setting.working_hours.present?
  end


  # Fix a bug/issue/by-design(?) of browsers that have a hard time understanding
  # what to do about our ajax search page. This header tells browsers to not cache
  # the current contents of the page because previously when someone filtered results,
  # went to the listing's external site, then hit Back, they'd only see the last
  # ajax response snippet, not the full listings page for their search.
  #
  # Heated multi-year discussion on this issue in Chrome
  # https://code.google.com/p/chromium/issues/detail?id=94369
  #
  # And continued by the Rails team:
  # https://github.com/rails/jquery-ujs/issues/318
  # https://github.com/rails/jquery-rails/issues/121
  def set_vary_header
    if request.xhr?
      response.headers['Vary'] = 'accept'
    end
  end

  def choose_layout
    %w(preview payments_history).include?(action_name) ? 'preview_mode' : 'application'
  end

  def filter_by_company(elem, tbl=params[:controller])
    # set company dropdown session and save in database if company is changed
    unless params[:company_id].blank?
      session['current_company'] = params[:company_id]
      current_user.update_attributes(current_company: params[:company_id])
    end
    elem.where("#{tbl}.company_id IN(?)", [1])
  end

end
