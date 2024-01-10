class ErrorsController < ApplicationController
  before_filter :set_status

  def show
    flash.alert = "Status #{@status}"
    render @status.to_s, status: @status
  end

  protected

  #Info
  def set_status
    @exception = env['action_dispatch.exception']
    @status = params[:code] || ActionDispatch::ExceptionWrapper.new(env, @exception).status_code
  end
end

