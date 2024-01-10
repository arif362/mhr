# == Schema Information
#
# Table name: attendance_attendances
#
#  id            :integer          not null, primary key
#  in_date       :date
#  in_time       :datetime
#  out_time      :datetime
#  duration      :float(24)
#  employee_id   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  department_id :integer
#

module Attendance
  class Attendance < Attendance::Base
    belongs_to :employee
    belongs_to :department
    validates :in_date, :in_time, :department_id, :employee_id, presence: true
    has_many :attendance_attendance_logs, :class_name => 'Attendance::AttendanceLog'
    before_save :set_duration
    validate :check_out_time

    def self.report(department, start_date, end_date, employee_id = nil)
      if employee_id.present?
        employees = department.employees.where(id: employee_id)
        attendances = employees.first.attendances.where(in_date: start_date..end_date)
      else
        employees = department.employees.where('is_active = ? OR deactivate_date > ?', true, start_date).where('invitation_token IS NULL')
        attendances = department.attendances.where(in_date: start_date..end_date)
      end
      report = initialize_report(employees, department.setting, start_date, end_date)
      report = update_settings_data(department, employees, report, start_date, end_date)
      report = update_report_with_day_offs(department, employees, report, start_date, end_date)
      report = update_report_with_leaves(department, report, start_date, end_date)
      update_report_with_attendances(attendances, report, department)
    end

    def self.initialize_report(employees, default_settings, start_date, end_date)
      report = {}
      employees.each do |employee|
        report[employee.id] = {
            employee: employee
        }
        (start_date..end_date).each do |date|
          day_report = {
              open_time: default_settings.open_time,
              working_hours: default_settings.working_hours,
              in_time: '',
              out_time: '',
              total_duration: 0,
              over_time: 0,
              late_time: 0,
              day_off: nil,
              leave_status: nil
          }

          report[employee.id][date.day] = day_report
        end
      end
      report
    end

    def self.update_settings_data(department, employees, report, start_date, end_date)
      changed_settings = department.changed_settings.where('(from_date <= ? AND to_date >= ?) OR (from_date >= ? AND to_date <= ?) OR (to_date >= ? AND from_date <= ?)', start_date, start_date, start_date, end_date, end_date, end_date)
      changed_settings.each do |changed_setting|
        from_date = changed_setting.from_date
        to_date = changed_setting.to_date

        init_date = from_date > start_date ? from_date : start_date
        last_date = to_date < end_date ? to_date : end_date

        (init_date..last_date).each do |date|

          employees.each do |employee|

            if report[employee.id][date.day].present?
              report[employee.id][date.day][:open_time] = changed_setting.open_time
              report[employee.id][date.day][:working_hours] = changed_setting.working_hours
            end

          end

        end

      end

      report
    end

    def self.update_report_with_day_offs(department, employees, report, start_date, end_date)
      day_offs = department.day_offs.where(date: start_date..end_date)
      day_offs.each do |day_off|
        employees.each do |employee|
          report[employee.id][day_off.date.day][:day_off] = day_off if report[employee.id][day_off.date.day].present?
        end
      end

      report
    end

    def self.update_report_with_leaves(department, report, start_date, end_date)
      leave_days = Leave::Day.includes(leave_application: [:employee, :leave_category]).where(day: start_date..end_date, is_approved: true).where('leave_applications.department_id = ? AND leave_applications.is_approved = ?', department.id, true).references(:leave_applications)
      leave_days.each do |leave_day|
        report[leave_day.leave_application.employee_id][leave_day.day.day][:leave_status] = leave_day.leave_application if report[leave_day.leave_application.employee_id].present? && report[leave_day.leave_application.employee_id][leave_day.day.day].present?
      end

      report
    end

    def self.update_report_with_attendances(attendances, report, department)
      attendances.each do |attendance|

        if report[attendance.employee_id].present?
          department_settings = department.get_settings(attendance.in_date)

          in_date_day = attendance.in_date.strftime('%d').to_i
          if report[attendance.employee_id][in_date_day][:in_time].present?
            if attendance.in_time < report[attendance.employee_id][in_date_day][:in_time]
              report = report_in_time(report, attendance, in_date_day, report[attendance.employee_id][in_date_day][:open_time])
            end
          else
            report = report_in_time(report, attendance, in_date_day, report[attendance.employee_id][in_date_day][:open_time])
          end

          if attendance.out_time.present?
            if report[attendance.employee_id][in_date_day][:out_time].present?
              if report[attendance.employee_id][in_date_day][:out_time] < attendance.out_time
                report[attendance.employee_id][in_date_day][:out_time] = attendance.out_time
              end
            else
              report[attendance.employee_id][in_date_day][:out_time] = attendance.out_time
            end
          end

          if attendance.duration.present? && attendance.duration > 0
            report[attendance.employee_id][in_date_day][:total_duration] += attendance.duration.to_i
            if report[attendance.employee_id][in_date_day][:over_time] > 0
              report[attendance.employee_id][in_date_day][:over_time] += attendance.duration.to_i
            else
              report[attendance.employee_id][in_date_day][:over_time] = get_overtime(report[attendance.employee_id][in_date_day][:total_duration], report[attendance.employee_id][in_date_day][:working_hours], report[attendance.employee_id][in_date_day][:day_off])
            end
          end
        end
      end

      report
    end

    def self.report_in_time(report, attendance, in_date_day, department_open_time)
      report[attendance.employee_id][in_date_day][:in_time] = attendance.in_time
      day_off = report[attendance.employee_id][in_date_day][:day_off]
      if day_off.present?
        if day_off.day_off_type == AppSettings::DAYOFF_TYPES[:custom_holiday]
          report[attendance.employee_id][in_date_day][:late_time] = get_late_time(attendance.in_date, department_open_time, attendance.in_time)
        end
      else
        report[attendance.employee_id][in_date_day][:late_time] = get_late_time(attendance.in_date, department_open_time, attendance.in_time)
      end

      report
    end

    def self.get_overtime(worked_hour, working_hours, day_off)
      if working_hours.present?
        working_hour = (working_hours * 60 * 60).to_i

        off_hours = 0
        if day_off.present?
          if day_off.day_off_type == AppSettings::DAYOFF_TYPES[:custom_holiday]
            off_hours = (day_off.hours * 60 * 60).to_i
          else
            off_hours = working_hour
          end
        end
        should_worked = working_hour - off_hours


        if worked_hour > should_worked
          worked_hour - should_worked
        else
          0
        end
      end
    end

    def self.attendance_report(department, employee, start_date, end_date)

      report = {################# all hour values in unit second ##################
                late_time: 0,
                over_time: 0,
                worked_hour: 0,
                extra_present_days: 0,
                present_days: 0,
                less_worked_hour: 0,
                late_days: 0
      }

      # start_date = Date.new(year, month, 1)
      # end_date = start_date.end_of_month
      attendances = employee.attendances.where(in_date: start_date..end_date)
      department_settings_data = department.get_settings_data(department.setting, start_date, end_date)

      (start_date..end_date).each do |date|
        dated_attendances = attendances.where(in_date: date).order(:in_time)

        if dated_attendances.present? && dated_attendances.length > 0

          worked_hour = dated_attendances.sum(:duration).to_i
          report[:worked_hour] += worked_hour
          day_offs = department.day_offs.where(date: date)
          working_hour = (department_settings_data[date.day][:working_hours] * 60 * 60).to_i


          late_time = 0
          off_hours = 0
          if day_offs.present? && day_offs.size > 0
            day_off = day_offs.first
            if day_off.day_off_type == AppSettings::DAYOFF_TYPES[:custom_holiday]
              off_hours = (day_off.hours * 60 * 60).to_i
              late_time = get_late_time(date, department_settings_data[date.day][:open_time], dated_attendances.first.in_time)
            else
              off_hours = working_hour
            end
            report[:extra_present_days] += 1
          else
            report[:present_days] += 1
            late_time = get_late_time(date, department_settings_data[date.day][:open_time], dated_attendances.first.in_time)
          end

          should_worked = working_hour - off_hours

          report[:late_time] += late_time
          if late_time > 0
            report[:late_days] += 1
          end

          if worked_hour > should_worked
            report[:over_time] += (worked_hour - should_worked)
            # granted_over_time = worked_hour - should_worked
            # if department_settings.min_over_time.present? && over_time < department_settings.min_over_time
            #   granted_over_time = 0
            # end
            # if department_settings.max_over_time.present? && over_time > department_settings.max_over_time
            #   granted_over_time = 0
            # end
          elsif worked_hour < should_worked
            report[:less_worked_hour] += (should_worked - worked_hour)
          end
        end
      end
      report
    end

    def self.get_late_time(date, dept_open_time, emp_in_time)
      if dept_open_time.present?
        dept_open_time = (date.to_s + ' ' + dept_open_time.strftime('%H:%M:%S').to_s).to_datetime
        emp_in_time = (date.to_s + ' ' + emp_in_time.strftime('%H:%M:%S')).to_datetime
        late_time = ((emp_in_time - dept_open_time) * 24 * 60 * 60).to_i
        late_time > 0 ? late_time : 0
      else
        0
      end
    end

    def on_time_or_late_checker(employee, date, department)
      first_in_time = department.attendances.where('employee_id = ? and in_date = ?', employee, date).first
      setting = department.get_settings(date)
      if first_in_time.present? && setting.open_time.present? && first_in_time.in_time.strftime("%H%M%S%N") <= setting.open_time.strftime("%H%M%S%N")
        "<span class='success-color'> On Time </span>"
      elsif first_in_time.present? && setting.open_time.present? && first_in_time.in_time.strftime("%H%M%S%N") > setting.open_time.strftime("%H%M%S%N")
        "<span class='warning-color'> Late </span>"
      else
        '-'
      end
    end

    def self.in_time_second(in_time = nil)
      if in_time.present?
        ((in_time.sec || 0) + (in_time.min * 60) + (in_time.hour * 60 * 60)).to_f
      else
        0
      end
    end

    def self.out_time_second(out_time = nil)
      if out_time.present?
        ((out_time.sec || 0) + (out_time.min * 60) + (out_time.hour * 60 * 60)).to_f
      else
        0
      end
    end

    def self.get_stats(attendances)
      stats = {}
      attendances.each do |attendance|
        day = attendance.in_date.day
        if stats[day].present?
          if !stats[day][:in_time].present? || (stats[day][:in_time].present? && attendance.in_time < stats[day][:in_time])
            stats[day][:in_time] = attendance.in_time
          end


          if attendance.out_time.present?
            if !stats[day][:out_time].present? || (stats[day][:out_time].present? && attendance.out_time > stats[day][:out_time])
              stats[day][:out_time] = attendance.out_time
            end
          end

          stats[day][:duration] += attendance.duration if attendance.duration.present?
        else
          stats[day] = {
              in_time: attendance.in_time.present? ? attendance.in_time : nil,
              out_time: attendance.out_time.present? ? attendance.out_time : nil,
              duration: attendance.duration.present? ? attendance.duration : 0.0
          }
        end
      end

      p stats.inspect
      total_in_time = 0.0
      total_out_time = 0.0
      total_hour = 0.0
      total_present = 0
      stats.each do |day, value|
        total_in_time += self.in_time_second(value[:in_time])
        total_out_time += self.out_time_second(value[:out_time])
        total_hour += value[:duration]
        total_present += 1
      end

      {total_in_time: total_in_time / total_present.to_f, total_out_time: total_out_time / total_present.to_f, avg_hours: total_hour / total_present.to_f, total_hours: total_hour, total_present: total_present}
    end

    protected

    def check_out_time
      if in_time && out_time && in_time > out_time
        errors.add(:in_time, 'cannot be greater than out time')
      end
    end

    def set_duration
      if in_time.present? && out_time.present?
        self.duration = out_time - in_time
      else
        self.duration = ''
      end
    end
  end
end

