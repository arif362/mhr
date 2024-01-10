# == Schema Information
#
# Table name: employees_advances
#
#  id             :integer          not null, primary key
#  employee_id    :integer
#  amount         :float(24)
#  is_paid        :boolean          default(FALSE)
#  purpose        :text(65535)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  department_id  :integer
#  is_deactivated :boolean          default(FALSE)
#  is_completed   :boolean          default(FALSE)
#  installment    :float(24)
#  return_policy  :string(255)
#  date           :date
#

module Employees
  class Advance < Base
    belongs_to :employee
    belongs_to :department
    has_many :advance_returns, :class_name => 'Employees::AdvanceReturn', dependent: :destroy
    validates_presence_of :employee_id, :amount, :date


    # Callbacks

    after_create :send_email_notification

    def self.employees_take_advance(current_department, advances = nil)
      unless advances.present?
        advances = not_completed(current_department)
      end
      advances.group_by { |adv| adv.employee_id }.map { |key, advs| [advs.first.employee.full_name, advs.first.employee_id] }
    end

    def installment_amount
      if installment.present?
        (amount / installment).round(2)
      else
        0.0
      end
    end

    def self.not_completed(current_department, advances = nil)
      incomplete_advances = ''
      if advances.present?
        incomplete_advances = advances.where(is_completed: false)
      else
        incomplete_advances = current_department.advances.where(is_completed: false)
      end
      incomplete_advances
    end

    def returned
      self.advance_returns.sum(:amount)
    end

    def self.search(current_department, start_date, end_date, status = nil, employee_id = nil)
      advances = ''
      if employee_id.present?
        if status.present? && status == Employees::AdvanceReturn::STATUS[:all]
          advances = current_department.advances.where(date: start_date..end_date, employee_id: employee_id).includes(:employee).order(id: :desc)
        elsif status.present? && status == Employees::AdvanceReturn::STATUS[:completed]
          advances = current_department.advances.where(date: start_date..end_date, is_completed: true, employee_id: employee_id).includes(:employee).order(id: :desc)
        else
          advances = current_department.advances.where(date: start_date..end_date, is_completed: false, employee_id: employee_id).includes(:employee).order(id: :desc)
        end
      else
        if status.present? && status == Employees::AdvanceReturn::STATUS[:all]
          advances = current_department.advances.where(date: start_date..end_date).includes(:employee).order(id: :desc)
        elsif status.present? && status == Employees::AdvanceReturn::STATUS[:completed]
          advances = current_department.advances.where(date: start_date..end_date, is_completed: true).includes(:employee).order(id: :desc)
        else
          advances = current_department.advances.where(date: start_date..end_date, is_completed: false).includes(:employee).order(id: :desc)
        end
      end
      advances
    end

    def self.report(current_department, employee_id = nil, advance = nil)
      advance_report = []
      advances = []
      if advance.present?
        advance_report.push({date: advance.date, employee: advance.employee, given: advance.amount, return: '-'})
        advance_returns = current_department.advance_returns.where(advance_id: advance.id).includes(:employee)
      elsif employee_id.present?
        advances = current_department.advances.where(employee_id: employee_id).includes(:employee)
        advance_returns = current_department.advance_returns.where(employee_id: employee_id).includes(:employee)
      else
        advances = current_department.advances.includes(:employee)
        advance_returns = current_department.advance_returns.includes(:employee)
      end
      advances.each do |adv|
        advance_report.push({date: adv.date, employee: adv.employee, given: adv.amount, return: '-'})
      end
      advance_returns.each do |adv_ret|
        advance_report.push({date: adv_ret.date, employee: adv_ret.employee, given: '-', return: adv_ret.amount})
      end
      advance_report.sort_by! { |report| report[:date] }
    end

    def self.initial_balance(current_department, date, employee_id = nil)
      advance_amount = 0.0
      return_amount = 0.0
      if employee_id.present?
        advance_amount = current_department.advances.where('date < ?', date).where(employee_id: employee_id).sum(:amount)
        return_amount = current_department.advance_returns.where('date < ?', date).where(employee_id: employee_id).sum(:amount)
      else
        advance_amount = current_department.advances.where('date < ?', date).sum(:amount)
        return_amount = current_department.advance_returns.where('date < ?', date).sum(:amount)
      end
      return_amount - advance_amount
    end

    def send_email_notification
      NotificationMailer.employee_advance(self).deliver_now
    end

  end
end

