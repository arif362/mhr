module Attendance
  class AttendancesController < Attendance::BaseController
    before_filter :current_ability
    before_action :set_attendance, only: [:show, :edit, :update, :destroy, :out]
    before_action -> { permit_module(controller_name.classify.constantize) }

    def index
      attendance_date = params[:date].present? ? params[:date].to_date : Date.today
      @prev = attendance_date - 1.day
      @next = attendance_date + 1.day
      @attendances = current_department.attendances.includes(:employee).where(in_date: attendance_date).order(id: :desc)
      absent_employees = current_department.active_employees(attendance_date) - @attendances.map(&:employee)
      @weekend = current_department.day_offs.where(date: attendance_date).select(:day_off_type, :hours)

      @absent_data = []
      absent_employees.each do |employee|
        leave = employee.on_leave(attendance_date)
        @absent_data.push({employee: employee, leave_application: leave.present? ? leave.leave_application : ''})
      end
      respond_to do |format|
        format.html
        format.xls do
          render xls: 'Attendances', layout: 'excel', template: 'attendance/attendances/attendance_list_xls_docx.html.erb', encoding: 'utf-8'
        end
        format.pdf do
          render pdf: 'Attendances', layout: 'pdf', template: 'attendance/attendances/attendance_list_pdf.html.erb', encoding: 'utf-8'
        end
        format.docx do
          render docx: 'Attendances', layout: 'document', template: 'attendance/attendances/attendance_list_xls_docx.html.erb', encoding: 'utf-8'
        end
      end
    end

    def show
    end

    def new
      @attendance = Attendance.new
      @employee = Employee.find_by_id(params[:employee_id])
      @date = params[:selected_date] || Date.today
      respond_to do |format|
        format.js {}
      end
    end

    def edit
      respond_to do |format|
        format.js {}
      end
    end

    def stats
      @employee = nil
      @attendances = []
      @stats = {}
      start_date = params[:date].present? ? Date.new(params[:date][:year].to_i, params[:date][:month].to_i) : Date.today.beginning_of_month
      end_date = start_date.end_of_month
      if params[:employee_id].present?
        @employee = current_department.employees.find_by_id(params[:employee_id])
        @attendances = @employee.attendances.where(in_date: start_date..end_date).order(id: :desc)
        @stats = Attendance.get_stats(@attendances)
        @stats[:month] = Date::MONTHNAMES[start_date.month]
        p @stats.inspect
        # @stats[:total_hours] = @attendances.sum(:duration)
        # @stats[:total_in_time] = @attendances.to_a.sum(&:in_time_second)
        # @stats[:total_out_time] = @attendances.to_a.sum(&:out_time_second)
        # @stats[:total_present] = @attendances.group_by(&:in_date).count
      end
    end

    def create
      @employee = current_department.employees.find_by_id(params[:employee_id])
      if @employee.present?
        in_date = params[:in_date]
        in_time = in_date.to_s + ' ' + params[:attendance_attendance][:in_time]
        out_time = params[:attendance_attendance][:out_time].present? ? (in_date.to_s + ' ' + params[:attendance_attendance][:out_time]) : ''
        @attendance = @employee.attendances.build(in_date: in_date, in_time: in_time, out_time: out_time, department_id: @employee.department_id)
        respond_to do |format|
          if @attendance.save
            format.html { redirect_to employee_attendances_path(current_employee), notice: 'Attendance has been successfully created.' }
            format.js {}
            format.json { render json: @attendance, status: :ok }
          else
            format.html { render :new }
            format.js {}
            format.json { render json: @attendance.errors, status: :unprocessable_entity }
          end
        end
      end
    end

    def update
      respond_to do |format|
        @attendance = Attendance.find_by_id(params[:id])
        update_flag = false
        if params[:from_edit].present?
          out_time = params[:out_time].present? ? (@attendance.in_date.to_s + ' ' + params[:out_time].to_s) : ''
          in_time = params[:in_time].present? ? (@attendance.in_date.to_s + ' ' + params[:in_time].to_s) : ''
          update_flag = @attendance.update(in_time: in_time, out_time: out_time)
        else
          update_flag = @attendance.update(out_time: Time.now)
        end
        if update_flag
          format.html { redirect_to employee_attendances_path(current_employee), notice: 'Attendance was successfully updated.' }
          format.json { render json: @attendance, status: :ok }
          format.js { @attendances = todays_attendances(current_employee) }
        else
          format.html { render :edit }
          format.json { render json: @attendance.errors, status: :unprocessable_entity }
          format.js {}
        end
      end
    end

    def destroy
      @attendance.destroy
      attendance_date = Date.today
      if params[:additionals].present? && params[:additionals][:date].present?
        attendance_date = params[:additionals][:date]
      end
      attendances = @attendance.employee.attendances.where(in_date: attendance_date)
      unless attendances.present?
        leave = @attendance.employee.on_leave(attendance_date)
        @absent_data = {employee: @attendance.employee, leave_application: leave.present? ? leave.leave_application : ''}
      end
      respond_to do |format|
        format.js {}
      end
    end

    def in
      @attendance_date = Date.today
      @attendances = current_employee.attendances.where(in_date: @attendance_date)
      if @attendances.present? && @attendances.length > 0 && !@attendances.last.out_time.present?
        @already_in = true
      else
        @already_in = false
        @attendance = current_employee.attendances.build(in_date: @attendance_date, in_time: Time.now, department_id: current_employee.department_id)
        @attendance.save
      end

      respond_to do |format|
        format.js {}
      end
    end

    def out
      if @attendance.present?
        @attendance_date = Date.today
        @attendances = current_employee.attendances.where(in_date: @attendance_date)
        if @attendances.present? && @attendances.length > 0 && @attendances.last.out_time.present?
          @already_out = true
        else
          @already_out = false
          @attendance.update(out_time: Time.now)
        end
      end
      respond_to do |format|
        format.js
      end
    end

    def history
      start_date = Date.today.beginning_of_month
      end_date = Date.today

      if params[:daterange].present?
        date_range = params[:daterange].split('To')
        start_date = format_string_date(date_range.first)
        end_date = format_string_date(date_range.last)
      end
      @attendances = current_department.attendances.includes(:employee).where(in_date: start_date..end_date).group(:employee_id).select('employee_id, SUM(duration) as total_duration')
      @absent_employees = current_department.active_employees(start_date) - @attendances.map(&:employee)

      respond_to do |format|
        format.html
        format.xls do
          render xls: 'Attendance History', layout: 'excel', template: 'attendance/attendances/history_xls_docx.html.erb', encoding: 'utf-8'
        end
        format.pdf do
          render pdf: 'Attendance History', layout: 'pdf', template: 'attendance/attendances/history_pdf.html.erb', encoding: 'utf-8'
        end
        format.docx do
          render docx: 'Attendance History', layout: 'document', template: 'attendance/attendances/history_xls_docx.html.erb', encoding: 'utf-8'
        end
      end
    end

    def report
      if check_department_settings
        @start_date = Date.today.beginning_of_month
        if params[:date].present?
          @start_date = Date.new(params[:date][:year].to_i, params[:date][:month].to_i)
        end
        @end_date = @start_date.end_of_month
        @attendance_report = Attendance.report(current_department, @start_date, @end_date)
        respond_to do |format|
          format.html
          format.xls do
            render xls: 'Attendance Report', layout: 'excel', template: 'attendance/attendances/report_xls_docx.html.erb', encoding: 'utf-8'
          end
          format.pdf do
            render pdf: 'Attendance Report', layout: 'pdf', template: 'attendance/attendances/report_pdf.html.erb', encoding: 'utf-8'
          end
          format.docx do
            render docx: 'Attendance Report', layout: 'document', template: 'attendance/attendances/report_xls_docx.html.erb', encoding: 'utf-8'
          end
        end
      else
        redirect_to general_departments_path, notice: 'Please setup your departments general settings first.'
      end
    end

    def employee_wise_report
      if check_department_settings
        @employee = Employee.find_by_id(params[:employee_id]) || current_employee
        @start_date = Date.today.beginning_of_month
        @end_date = Date.today
        if params[:date].present?
          @start_date = Date.new(params[:date][:year].to_i, params[:date][:month].to_i, 1) #(params[:date][:year] + '-' + (params[:date][:month]).to_s + '-1').to_date
          @end_date = @start_date.end_of_month
        end
        @attendance_report = Attendance.report(current_department, @start_date, @end_date, @employee.id)
        respond_to do |format|
          format.html
          format.xls do
            render xls: 'Attendance Report Breakdown', layout: 'excel', template: 'attendance/attendances/employee_wise_report_xls_docx.html.erb', encoding: 'utf-8'
          end
          format.pdf do
            render pdf: 'Attendance Report Breakdown', layout: 'pdf', template: 'attendance/attendances/employee_wise_report_pdf.html.erb', encoding: 'utf-8'
          end
          format.docx do
            render docx: 'Attendance Report Breakdown', layout: 'document', template: 'attendance/attendances/employee_wise_report_xls_docx.html.erb', encoding: 'utf-8'
          end
        end
      else
        redirect_to general_departments_path, notice: 'Please setup your departments general settings first.'
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_attendance
      begin
        @attendance = Attendance.find(params[:id])
      rescue
        @attendance = nil
      end
    end
  end
end

