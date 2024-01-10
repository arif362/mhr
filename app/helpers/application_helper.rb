module ApplicationHelper
  def inline_validation(object, field)
    if object.errors.present?
      if object.errors[field.to_sym].present?
        meg = object.errors[field.to_sym].join(' and ')
        raw "<span class='validation-error' style='color:red'> #{meg} </span>"
      end
    end
  end

  def in_out_button_select(employee, dashboard = nil)
    if current_employee == employee
      attendances = todays_attendances(employee)
      if attendances.present? && attendances.first.out_time.nil?
        link_to 'Out', out_attendance_attendance_path(attendances.first, dashboard: dashboard), remote: true, method: :get, id: 'employee_attendances', class: 'btn btn-danger reset-border-radius btn-md out-btn btn-block'
      else
        link_to 'In', in_attendance_attendances_path(dashboard: dashboard), remote: true, method: :get, id: 'employee_attendances', class: 'btn btn-success btn-md btn-block in-btn reset-border-radius'
      end
    end
  end

  def employee_avatar(employee, klass = 'image-responsive ')
    html = "<div class='table-class'>"
    if employee.image_url.present?
      html += image_tag(employee.image_url, class: klass)
    else
      html += "<div style='background:  #{employee.color.present? ? employee.color : '#'+SecureRandom.hex(3) }; text-align: center;' class='short-name-image'> #{employee.short_name} </div>"
    end
    raw html + "</div>"
  end

  def format_date(new_date)
    new_date.strftime('%d %B, %Y') if new_date.present?
  end

  def format_date_2(new_date)
    new_date.strftime('%d %b') if new_date.present?
  end

  def format_date_3(new_date)
    new_date.strftime('%d %b, %Y') if new_date.present?
  end

  def get_time_from_datetime(new_date_time)
    new_date_time.strftime('%I:%M:%S %p') if new_date_time.present?
  end

  def get_budget_amount(cat, year)
    budget = cat.expenses_budgets.where(year: year)
    if budget.present?
      budget.first.amount
    else
      0
    end
  end

  def get_budget_id(cat, year)
    budget = cat.expenses_budgets.where(year: year)
    if budget.present?
      budget.first
    end
  end

  def get_total_budget(year)
    budget = @cur_department.expenses_budgets.where(year: year)
    if budget.present?
      budget.sum(:amount)
    else
      0
    end
  end

  def format_duration(duration)
    if duration.present?
      hours = duration / (60.0 * 60.0)
      minutes = (duration / 60.0) % 60.0
      #seconds = duration % 60
      duration_text = ''
      duration_text = hours < 10 ? "0#{hours.to_i}" : "#{hours.to_i}"
      duration_text += minutes < 10 ? ":0#{minutes.to_i}" : ":#{minutes.to_i}"
    else
      '-'
    end
  end

  def custom_checkbox(name, value, options = {}, klass = '')
    html_options = ''
    options.each do |key, val|
      html_options += " #{key}='#{val}'"
    end
    <<HTML
    <div class="checkbox #{klass}">
      <label for="#{name}_#{value}">
        <input id="#{name}_#{value}" type='checkbox' name="#{name}" value="#{value}"#{html_options}/>
        <span class='cr'>
             <i class='cr-icon fa fa-check'></i>
        </span>
        <b> </b>
      </label>
    </div>
HTML
  end


  def can_access?(action, controller)
    current_ability ||= ::Ability.new(current_employee, current_namespace(controller), controller, action)
    current_ability.can? action.to_sym, controller.classify
  end

  def cannot_access?(action, controller)
    current_ability ||= ::Ability.new(current_employee, current_namespace(controller), controller, action)
    current_ability.cannot? action.to_sym, controller.classify
  end


  def can_settings_access?
    hash = [
        {controller: 'settings', action: 'index'},
        {controller: 'companies', action: 'profile'},
        {controller: 'departments', action: 'show'}
    ]
    hash.each do |hs|
      return true if can_access?(hs[:action], hs[:controller])
    end
    return false
  end


  def link_to(name = nil, options = nil, html_options = nil, &block)
    request_on = block_given? ? name : options
    controller_attributes = attributes_retrieval(request_on)
    if controller_attributes[:controller].present? && controller_attributes[:action].present?
      super if can_access? controller_attributes[:action], controller_attributes[:controller]
    else
      super
    end
  end


  def departments
    current_department.present? ? current_department.company.departments : []
  end

  def check_for_active_module(module_name)
    request_module = controller_path.split('/').first
    p "#{controller_path} | Request module: #{request_module}"
    request_module.downcase == module_name.downcase
  end

  def get_module_menus
    request_module = controller_path.split('/').first.downcase
    if AppSettings::MODULES_NAME.include? request_module
      render "shared/#{request_module}/nav_menu"
    end
  end

  def leave_pending_notification
    # start_time = params[:date].present? ? Time.new(params[:date][:year].to_i) : Date.today.at_beginning_of_year
    # end_time = start_time.at_end_of_year
    # current_department.leave_applications.where(status: AppSettings::STATUS[:pending], created_at: start_time..end_time).count
    current_department.present? ? current_department.leave_applications.where(status: AppSettings::STATUS[:pending]).count : 0
  end

  def get_module_pic
    request_module = controller_path.split('/').first.downcase
    if AppSettings::MODULES_NAME.include? request_module
      "module_settings/white_icon/#{request_module}.png"
    end
  end

  def amount_with_currency(amount)
    dep_setting = current_department.setting
    if dep_setting.present? && dep_setting.currency.present?
      return "#{dep_setting.currency.upcase} #{amount}"
    end
    amount
  end

  def work_progress(tasks)
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

    if percentage > 75
      klass = 'bg-success'
    elsif percentage >= 50
      klass = 'bg-warning'
    else
      klass = 'bg-danger'
    end

    raw "<div class='progress mb0' style='width: 300px; display: inline-block; vertical-align: bottom;'>
         <div class='progress-bar #{klass}' style='width:#{percentage}%'> #{percentage}% </div>
    </div>"
  end

  private

  def is_authorized_to_see?(attrs, perms)
    employee_signed_in? ? employee_admin(attrs, perms) : true
  end

  def employee_admin(attrs, perms)
    current_employee.super_admin? ? true : authentication_check(attrs, perms)
  end

  def authentication_check(attrs, perms)
    is_authentic = false
    if perms[:can][attrs[:action].to_sym].present?
      is_authentic = perms[:can][attrs[:action].to_sym].include? attrs[:controller].classify
    end
    is_authentic
  end


  def attributes_retrieval(request_on)
    request_on_attributes = request_on.is_a?(Hash) ? request_on : convert_url_to_hash(request_on)
    request_on_attributes[:url].present? ? convert_url_to_hash(request_on_attributes[:url]) : request_on_attributes
  end

  def convert_url_to_hash(url)
    Rails.application.routes.recognize_path(url)
    # Rails.application.routes.recognize_path(request.referer)
  end

  def hour_from_second(second)
    # result = second.to_f / 3600.00
    # number_with_precision(result, precision: 2)
    (second.to_f / 3600.00).round(2)
  end

  def country_name(object)
    if object.country.present?
      object_country = ISO3166::Country[object.country]
      object_country.translations[I18n.locale.to_s] || object_country.name
    else
      ''
    end
  end

  # generic query string for all filter links
  def query_string(params)
    "&page=#{params[:page]}&per=#{params[:per]}&company_id=#{params[:company_id]}&sort=#{params[:sort]}&direction=#{params[:direction]}"
  end

  def get_count(params)
    elem = params[:controller]
    model = elem.classify.constantize
    company_id = current_department.id #session['current_company'] || current_user.current_company || current_user.first_company_id

    if %(clients items staffs tasks).include?(elem)
      account = params[:user].current_account
      (account.send(elem).send(params[:status]) + Company.find(company_id).send(elem).send(params[:status])).size
    else
#      model.where("company_id IN(?)", company_id).send(params[:status]).count
    end
  end

  def sortable_class(column)
    if column == sort_column
      sort_direction == "asc" ? "sortup" : "sortdown"
    else
      ''
    end
  end

  def number_to_currency1(number, options={})
    return nil unless number
    symbol       = options[:unit] || 'USD'
    precision    = options[:precision] || 2
    old_currency = number_to_currency(number, {precision: precision})
    old_currency.chr=='-' ? old_currency.slice!(1) : old_currency.slice!(0)
    ("#{old_currency} <div class=#{(options[:unit_size]||'unit-default')}>#{symbol} </div>").html_safe
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, :page => 1), {:class => "#{css_class} sortable", :remote => true}
  end
end
