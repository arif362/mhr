class ChangedSettingsController < ApplicationController

  before_action :set_changed_setting, only: [:edit, :update, :destroy]

  def new
    @changed_setting = ChangedSetting.new
  end

  def create
    @changed_setting = current_department.changed_settings.build(changed_setting_params)
    @changed_setting.save
  end

  def edit
  end

  def update
    @changed_setting.update(changed_setting_params)
  end

  def destroy
    @changed_setting.destroy
  end

  private

  def set_changed_setting
    @changed_setting = ChangedSetting.find_by_id(params[:id])
  end

  def changed_setting_params
    params.require(:changed_setting).permit!
  end
end
