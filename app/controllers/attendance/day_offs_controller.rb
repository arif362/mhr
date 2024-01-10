class Attendance::DayOffsController < ApplicationController
  before_filter :current_ability

  def new
    @day_off = current_department.day_offs.find_or_initialize_by(date: params[:date])
  end

  def create
    @day_off = current_department.day_offs.build(day_off_params)
    respond_to do |format|
      @day_off.save
      format.js
    end
  end

  def update
    @day_off = current_department.day_offs.find_by_id(params[:id])
    respond_to do |format|
      @day_off.update_attributes(day_off_params)
      format.js
    end
  end

  def destroy
    @day_off = current_department.day_offs.find_by_id(params[:id])
    respond_to do |format|
      @day_off.destroy
      format.js
    end
  end

  def generate
    @day_offs = []
    if params[:weekend].present?
      weekend = params[:weekend]
      department= params[:department]
      start_year = Date.today.beginning_of_year
      end_year = start_year.end_of_year
      (start_year..end_year).each do |date|
        if date.strftime('%A') == weekend.capitalize
          department = params[:department].present? ? Department.find(params[:department]) : current_department
          dayoff = department.day_offs.find_or_initialize_by(date: date)
          dayoff.day_off_type = 'Weekend'
          dayoff.title = 'Weekend'
          if dayoff.save
            @day_offs.push({id: dayoff.id, title: dayoff.title, start: dayoff.date})
          end
        end
      end
    end
  end

  private

  def day_off_params
    params.require(:attendance_day_off).permit!
  end
end