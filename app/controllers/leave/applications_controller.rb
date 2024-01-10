module Leave
  class ApplicationsController < Leave::BaseController
    before_filter :current_ability
    before_action :set_leave_application, only: [:show, :edit, :update, :destroy]
    # GET /applications
    # GET /applications.json
    def index
      start_time = params[:date].present? ? Time.new(params[:date][:year].to_i) : Date.today.at_beginning_of_year
      end_time = start_time.at_end_of_year
      if params[:q].present?
        @leave_applications = current_department.leave_applications.where(status: params[:q], created_at: start_time..end_time).order(id: :desc)
      else
        @leave_applications = current_department.leave_applications.where(created_at: start_time..end_time).order(id: :desc)
      end

      @pending_count = current_department.leave_applications.where(status: AppSettings::STATUS[:pending], created_at: start_time..end_time).count
      respond_to do |format|
        format.html
        format.js
      end
    end

    def leave_status
      leave_status_data(params[:employee_id], params[:date].present? ? params[:date][:year] : Date.today.year)
      respond_to do |format|
        format.html
        format.js
      end
    end

    def leave_attachment
      uploaded_attachment = Leave::Application.find_by_id(params[:id]).attachment
      send_file uploaded_attachment.path,
                :filename => uploaded_attachment,
                :type => uploaded_attachment,
                :disposition => 'attachment'

    end

    def employee_status
      year = params[:date].present? ? params[:date][:year].to_i : Date.today.year
      @employee = params[:employee_id].present? ? current_department.employees.find_by_id(params[:employee_id]) : current_employee
      @result = Leave::Application.employee_status(current_department, @employee, year)
      respond_to do |format|
        format.html {}
        format.xls do
          render xls: 'Leave Applications Summary', layout: 'excel', template: 'leave/applications/employee_status_xls_docx.html.erb', encoding: 'utf-8'
        end
        format.pdf do
          render pdf: 'Employee Leave Status', layout: 'pdf', template: 'leave/applications/employee_status_pdf.html.erb', encoding: 'utf-8'
        end
        format.docx do
          render docx: 'Leave Applications Summary', layout: 'document', template: 'leave/applications/employee_status_xls_docx.html.erb', encoding: 'utf-8'
        end
      end
    end

    # GET /applications/1
    # GET /applications/1.json
    def show
      unless params[:no_admin]
        taken_days = @leave_application.leave_category.leave_applications.where(is_approved: true, is_paid: true, employee_id: @leave_application.employee_id).sum(:total_days)
        @remain = @leave_application.leave_category.days(@leave_application.created_at.year) - taken_days
      end
      respond_to do |format|
        format.html
        format.js
      end
    end

    def download
      @leave_application = current_department.leave_applications.find_by_id(params[:application_id])
      respond_to do |format|
        format.pdf do
          render pdf: 'Leave Application', layout: 'pdf', template: 'leave/applications/application_pdf.html.erb', encoding: 'utf-8'
        end
      end
    end

    # GET /applications/new
    def new
      employee = current_department.employees.find_by_id(params[:employee])
      @leave_application = employee.leave_applications.build
      @leave_categories = current_department.leave_categories.active
      respond_to do |format|
        format.html
        format.js
      end
    end

    # GET /applications/1/edit
    def edit
    end

    # POST /applications
    # POST /applications.json
    def create
      @leave_application = current_department.leave_applications.build(leave_application_params)
      @leave_application.employee_id = current_employee.id unless leave_application_params[:employee_id].present?
      @leave_application.is_paid = true if params[:leave_type].present? && params[:leave_type] == AppSettings::LEAVE_TYPES[:paid]
      days = params[:leave_days].present? ? params[:leave_days].split(',') : []
      @leave_application.total_days = days.size
      respond_to do |format|
        if @leave_application.save
          days.each do |day|
            @leave_application.leave_days.create(day: day)
          end
          unless params[:year].to_i == Date.today.year
            leave_status_data(@leave_application.employee_id, Date.today.year)
          end
          format.html { redirect_to @leave_application, notice: 'Leave application was successfully created.' }
          format.json { render :show, status: :created, location: @leave_application }
          format.js
        else
          format.html { render :new }
          format.json { render json: @leave_application.errors, status: :unprocessable_entity }
          format.js
        end
      end
    end

    # PATCH/PUT /applications/1
    # PATCH/PUT /applications/1.json
    def update
      respond_to do |format|
        if @leave_application.update_attributes(leave_application_params)
          if @leave_application.is_approved
            @leave_application.status = AppSettings::STATUS[:approved]
            @leave_application.total_days = @leave_application.leave_days.where(is_approved: true).count
          else
            @leave_application.status = AppSettings::STATUS[:rejected]
            @leave_application.leave_days.each do |leave_day|
              leave_day.is_approved = false
              leave_day.save
            end
          end
          @leave_application.save
          @pending_leave = current_department.leave_applications.where(status: AppSettings::STATUS[:pending])
          @leave_applications = current_department.leave_applications - @pending_leave
          format.html { redirect_to @leave_application, notice: 'Leave application was successfully updated.' }
          format.json { render :show, status: :ok, location: @leave_application }
          format.js
        else
          format.html { render :edit }
          format.json { render json: @leave_application.errors, status: :unprocessable_entity }
          format.js
        end

      end
    end

    def reject_application
      @leave_application = Leave::Application.find_by_id(params[:id])
      @leave_application.update_attributes(is_approved: false, status: AppSettings::STATUS[:rejected])
      @leave_days = @leave_application.leave_days
      @leave_days.each do |leave_day|
        leave_day.update_attributes(is_approved: false)
      end
      respond_to do |format|
        format.js {}
      end
    end


    # DELETE /applications/1
    # DELETE /applications/1.json
    def destroy
      @leave_application.destroy
      respond_to do |format|
        format.html { redirect_to leave_applications_url, notice: 'Leave application was successfully destroyed.' }
        format.json { head :no_content }
        format.js
      end
    end

    def report
      start_date = 1.month.ago.strftime("%Y-%m-%d")
      end_date = Date.today + 30.day
      @recent_leave_days = Leave::Day.leave_applications_from_date(start_date, end_date, current_department)
      selected_year = params[:date].present? ? params[:date][:year].to_i : Date.today.year
      start_date = Date.new(selected_year, 1, 1)
      end_date = Date.new(selected_year, 12, 31)

      @leave_days_in_a_year = Leave::Day.leave_applications_from_date(start_date, end_date, current_department)

      respond_to do |format|
        format.html {}
        format.js {}
      end
    end

    def summary
      selected_year = params[:date].present? ? params[:date][:year].to_i : Date.today.year
      start_date = Date.new(selected_year)
      end_date = start_date.end_of_year
      @leave_categories = current_department.leave_categories.of_the_year(selected_year)
      @leave_report = Leave::Application.get_leave_summary(current_department, @leave_categories, start_date, end_date)
      respond_to do |format|
        format.html {}
        format.xls do
          render xls: 'Leave Applications Summary', layout: 'excel', template: 'leave/applications/summary_xls_docx.html.erb', encoding: 'utf-8'
        end
        format.pdf do
          render pdf: 'Leave Applications Summary', layout: 'pdf', template: 'leave/applications/summary_pdf.html.erb', encoding: 'utf-8'
        end
        format.docx do
          render docx: 'Leave Applications Summary', layout: 'document', template: 'leave/applications/summary_xls_docx.html.erb', encoding: 'utf-8'
        end
      end
    end

    def leave_calendar
      @day_offs = []
      @leave_applications = current_department.leave_applications.includes(:leave_days, :employee).where(is_approved: true)
      @leave_applications.each do |application|
        application.leave_days.each do |leave_day|
          if leave_day.is_approved
            @day_offs.push({id: application.id, title: application.employee.full_name, start: leave_day.day})
          end
        end
      end
    end

    private

    def set_employee(employee)
      @employee = Employee.find(employee) || current_employee
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_leave_application
      @leave_application = Leave::Application.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def leave_application_params
      params.require(:leave_application).permit!
    end

    def leave_status_data(employee_id, year)
      @employee = set_employee(employee_id)
      start_time = Time.new(year.to_i)
      end_time = start_time.at_end_of_year
      @leave_applications = @employee.leave_applications.where(created_at: start_time..end_time).order(id: :desc)
      @leave_categories = @employee.department.leave_categories.of_the_year(start_time.year)
    end
  end
end
