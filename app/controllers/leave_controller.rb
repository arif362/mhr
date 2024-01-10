class LeaveController < ApplicationController
  before_filter :current_ability

  def dashboard
    from_date = Date.today
    to_date = from_date + 15.days
    @pending_requests = Leave::Application.where(department_id: current_department.id).where(status: 'pending')
    # @pending_requests = Leave::Application.request(current_department.id, false, from_date, to_date) # Pending leave application
    @approved_requests_today = Leave::Application.request(current_department.id, true, from_date).count # Approved leave application
    @other_requests_this_month = Leave::Application.request(current_department.id, true, from_date + 1.days, (from_date + 1.days).end_of_month).count # Approved leave application

  end
end
