# == Schema Information
#
# Table name: employees_advance_returns
#
#  id            :integer          not null, primary key
#  date          :date
#  amount        :float(24)
#  employee_id   :integer
#  department_id :integer
#  advance_id    :integer
#  salary_id     :integer
#  return_from   :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

module Employees
  class AdvanceReturn < Base
    RETURN_BY = {
        direct: 'Direct',
        salary: 'Salary'
    }
    STATUS = {
        not_completed: 'Incomplete',
        completed: 'Completed',
        all: 'All'
    }

    validates_presence_of :date, :amount, :employee_id, :advance_id

    belongs_to :employee
    belongs_to :department
    belongs_to :salary, class_name: 'Payroll::Salary'
    belongs_to :advance, class_name: 'Employees::Advance'

    # Callbacks

    after_create :send_email_notification

    def self.incomplete_advance_returns(current_department, employee_id = nil)
      if employee_id.present?
        includes(:advance).where(department_id: current_department.id, employee_id: employee_id).where('employees_advances.is_completed = ?', false).references(:employees_advances)
      else
        includes(:advance).where(department_id: current_department.id).where('employees_advances.is_completed = ?', false).references(:employees_advances)
      end
    end

    def send_email_notification
      NotificationMailer.employee_advance_return(self).deliver_now
    end

  end
end
