class SettingsController < ApplicationController
  before_filter :current_ability
  layout 'sessions'
  before_action :complete_profile, except: [:features, :billing, :company_feature, :payment_method]

  def index
    @features = Feature.all
    @selected_features = current_company.features
    @features_id = @selected_features.ids
    @monthly_cost = @selected_features.sum(:cost) + 2.50
    respond_to do |format|
      format.html
      format.js
    end
  end

  def features
    @features = Feature.all
    @features_id = []
    @selected_features = []
    @monthly_cost = @features.sum(:cost) + 2.50
    @remaining_cost = 0.0
  end

  def company_feature
    company = current_company
    if params[:features].present?
      company_features = params[:features]
      company_features.each do |feature|
        company.company_features.find_or_create_by(feature_id: feature)
      end
    end
    respond_to do |format|
      remove_feature(company, params[:features])
      format.html do
        company.update(next_path: AppSettings::REGISTRATION_STEPS[:payment])
        # redirect_to AppSettings::REGISTRATION_STEPS[:payment]
        redirect_to general_department_path(current_department)
      end
      format.js {}
    end
  end

  def billing

  end

  def payment_method
    company = current_department.company
    employee = company.employee
    respond_to do |format|
      if company.update(next_path: '')
        format.html { redirect_to department_path(current_department), notice: 'Company signup process completed' }
        format.json { status :ok }
      else
        format.html { redirect_to new_payment_method_settings_path, notice: "Payment method didn't created for #{current_department.company.name}" }
        format.json { status :unprocessable_entity }
      end
    end
  end

  def confirm
    @action_type = params[:action_type]
    @action_on = params[:action_on]
    @action_on_item = params[:action_item_id]
    @action_data = params[:action_data].present? ? params[:action_data] : ''
    respond_to do |format|
      format.js
    end
  end

  def update
    @settings = Setting.find(params[:id])
    @settings.update(setting_params)
    respond_to do |format|
      format.js
    end
  end

  private

  def remove_feature(company, requested_feature)
    if requested_feature.present?
      company.company_features.each do |feature|
        unless requested_feature.include? feature.feature_id.to_s
          feature.delete
        end
      end
    else
      company.features.delete_all
    end
  end

  def setting_params
    params.require(:setting).permit!
  end

  def company_feature_params
  end

end
