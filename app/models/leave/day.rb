# == Schema Information
#
# Table name: leave_days
#
#  id                   :integer          not null, primary key
#  day                  :date
#  leave_application_id :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  is_approved          :boolean          default(FALSE)
#

module Leave
  class Day < Leave::Base
    belongs_to :leave_application, :class_name => 'Leave::Application', foreign_key: :leave_application_id
    validates_presence_of :day

    def self.leave_applications_from_date(start_date, end_date, current_department)
      self.where(day: start_date.to_date..end_date.to_date, is_approved: true).group(:leave_application_id).select('leave_application_id').joins(:leave_application).where('leave_applications.department_id = ? AND leave_applications.is_approved = ?', current_department.id, true).references(:leave_applications)
    end

    def self.employee_leave_days(start_date, end_date, department_id, employee_id)
      self.where(day: start_date.to_date..end_date.to_date).group(:leave_application_id).select('leave_application_id').joins(:leave_application).where('leave_applications.department_id = ? AND leave_applications.employee_id = ?', department_id, employee_id).references(:leave_applications)
    end

    def self.paid_leave_applications_from_date(start_date, end_date, current_department)
      self.where(day: start_date.to_date..end_date.to_date, is_approved: true).group(:leave_application_id).select('leave_application_id').joins(:leave_application).where('leave_applications.department_id = ? AND leave_applications.is_approved = ? AND leave_applications.is_paid = ?', current_department.id, true, true).references(:leave_applications)
    end

    def self.approved_leave_days(current_department, employee_id, start_date, end_date)
      includes(:leave_application).where(day: start_date..end_date, is_approved: true).where('leave_applications.department_id = ? AND leave_applications.is_approved = ? AND leave_applications.employee_id = ?', current_department.id, true, employee_id).references(:leave_applications) #.group(:leave_application_id)
    end

    def self.approved_unpaid_leave_days(current_department, employee_id, start_date, end_date)
      includes(:leave_application).where(day: start_date..end_date, is_approved: true).where('leave_applications.department_id = ? AND leave_applications.is_approved = ? AND leave_applications.employee_id = ? AND leave_applications.is_paid = ?', current_department.id, true, employee_id, false).references(:leave_applications) #.group(:leave_application_id)
    end
  end
end
