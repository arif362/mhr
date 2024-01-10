# == Schema Information
#
# Table name: attendance_day_offs
#
#  id            :integer          not null, primary key
#  year          :integer
#  date          :date
#  day_off_type  :string(255)
#  hours         :float(24)
#  title         :string(255)
#  department_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Attendance::DayOff < Attendance::Base
  before_create :set_day_off_year
  DAYOFF_TYPE = {
      holiday: 'Holiday',
      custom_holiday: 'Custom Holiday'
  }
  belongs_to :department

  validates_presence_of :title, :date

  def set_day_off_year
    self.year = date.strftime('%Y') if date.present?
  end

  def self.day_off_report(current_department, start_date, end_date)
    report = {
        weekend_days: 0,
        holidays: 0,
        custom_holiday_hours: 0 #hours but in second
    }
    day_offs = current_department.day_offs.where(date: start_date..end_date)
    report[:weekend_days] = day_offs.where(day_off_type: AppSettings::DAYOFF_TYPES[:weekend]).count
    report[:holidays] = day_offs.where(day_off_type: AppSettings::DAYOFF_TYPES[:holiday]).count
    report[:custom_holiday_hours] = day_offs.where(day_off_type: AppSettings::DAYOFF_TYPES[:custom_holiday]).where.not(hours: nil).sum(:hours)
    report[:custom_holiday_hours] = report[:custom_holiday_hours] * 60 * 60
    report
  end
end
