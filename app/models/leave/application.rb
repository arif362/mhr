# == Schema Information
#
# Table name: leave_applications
#
#  id                :integer          not null, primary key
#  message           :text(65535)
#  note              :text(65535)
#  attachment        :string(255)
#  employee_id       :integer
#  leave_category_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  department_id     :integer
#  total_days        :integer
#  is_approved       :boolean          default(FALSE)
#  status            :string(255)      default("pending")
#  is_paid           :boolean          default(FALSE)
#

module Leave
  class Application < Leave::Base

    belongs_to :department
    belongs_to :employee
    belongs_to :leave_category, :class_name => 'Leave::Category', foreign_key: :leave_category_id

    has_many :leave_days, :class_name => 'Leave::Day', foreign_key: :leave_application_id, dependent: :destroy

    mount_uploader :attachment, FileUploader

    validates_presence_of :message, :employee_id, :leave_category_id
    accepts_nested_attributes_for :leave_days
    after_create :send_email_notification

    def self.request(department_id, status = true, from = nil, to = nil)
      leave_request = self.joins(:leave_days).where(is_approved: status, department_id: department_id)
      if from.present? && to.present?
        leave_date = (from.to_date..to.to_date)
      else
        from = from.to_date if from.present?
        to = to.to_date if to.present?
        leave_date = [from || to].compact
      end
      leave_date.present? ? leave_request.where('leave_days.day in (?)', leave_date) : leave_request
    end

    def self.get_leave_summary(current_department, categories, start_date, end_date)
      employees = current_department.employees.where('is_active = ? OR deactivate_date > ?', true, start_date).where('invitation_token IS NULL')
      applications = Leave::Day.leave_applications_from_date(start_date, end_date, current_department)
      leave_report = initialize_leave_report(employees, categories, start_date.year)
      leave_report = update_leave_report(leave_report, applications)
    end

    def self.initialize_leave_report(employees, categories, year)
      leave_report = {}
      employees.each do |employee|
        leave_report[employee.id] = {
            employee: employee,
            total_unpaid: 0
        }
        categories.each do |category|
          leave_report[employee.id][category.id] = {
              taken: 0,
              remaining: category.days(year)
          }
        end
      end
      leave_report
    end

    def self.update_leave_report(leave_report, leave_days)
      leave_days.each do |leave_day|
        if leave_day.leave_application.is_paid
          if leave_report[leave_day.leave_application.employee_id][leave_day.leave_application.leave_category_id].present?
            leave_report[leave_day.leave_application.employee_id][leave_day.leave_application.leave_category_id][:taken] += leave_day.leave_application.total_days
            leave_report[leave_day.leave_application.employee_id][leave_day.leave_application.leave_category_id][:remaining] -= leave_day.leave_application.total_days
          end
        else
          leave_report[leave_day.leave_application.employee_id][:total_unpaid] += leave_day.leave_application.total_days
        end
      end
      leave_report
    end

    def self.leave_report(current_department, employee, start_date, end_date)
      report = {
          total_leave: 0,
          taken_leave: 0,
          paid_leave: 0,
          unpaid_leave: 0
      }
      report[:total_leave] = current_department.leave_categories.total_leave_days(start_date.year) # Leave::Category.total_leave_days(current_department)\
      report[:taken_leave] = Leave::Day.approved_leave_days(current_department, employee.id, start_date, end_date).count
      report[:unpaid_leave] = Leave::Day.approved_unpaid_leave_days(current_department, employee.id, start_date, end_date).count
      report[:paid_leave] = report[:taken_leave] - report[:unpaid_leave]
      report
    end

    def send_email_notification
      NotificationMailer.leave_application(self).deliver_now
    end

    def self.employee_status(department, employee, year)
      result = initialize_result(department, year)
      get_updated_result(result, year, department.id, employee.id)
    end

    def self.initialize_result(department, year)
      result = {}

      leave_categories = department.leave_categories.of_the_year(year)
      leave_categories.each do |category|
        result[category.id] = {
            category_name: category.name,
            days: category.days(year),
            applications: [],
            applied: 0,
            approved: 0,
            others: 0,
            taken: 0,
            paid: 0,
            unpaid: 0
        }
      end

      result
    end

    def self.get_updated_result(result, year, department_id, employee_id)
      start_date = Date.new(year)
      end_date = start_date.end_of_year

      leave_days = Leave::Day.employee_leave_days(start_date, end_date, department_id, employee_id)

      leave_days.each do |leave_day|
        application = leave_day.leave_application
        cat_id = application.leave_category_id

        if result[cat_id].present?
          result[cat_id][:applications].push(application)
          result[cat_id][:applied] += 1

          if application.is_approved
            result[cat_id][:approved] += 1
            result[cat_id][:taken] += application.total_days
            application.is_paid ? result[cat_id][:paid] += application.total_days : result[cat_id][:unpaid] += application.total_days
          else
            result[cat_id][:others] += 1
          end

        end

      end

      result
    end
  end
end
