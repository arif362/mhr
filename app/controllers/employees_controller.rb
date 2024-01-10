class EmployeesController < InheritedResources::Base

  require 'barby'
  require 'chunky_png'
  require 'barby/barcode/code_128'
  require 'barby/outputter/png_outputter'

  skip_before_filter :authenticate_employee!, only: :login_as
  before_filter :current_ability
  before_action :set_employee, only: [:update_info, :edit, :show, :destroy, :payroll_categories, :increments, :activation]


  def new
    department_id = params[:department].present? ? params[:department] : current_department.id
    @employee = Employee.new(department_id: department_id)
    @designations = Designation.where(department_id: department_id, is_active: true)
    @employee.build_access_right
    current_department.payroll_categories.each do |category|
      @employee.payroll_employee_categories.build(category_id: category.id)
    end
    respond_to do |format|
      format.js
    end
  end

  def index
    if params[:all].present?
      @employees = Employee.search(current_department, params).order(id: :desc)
    else
      @employees = Employee.active.search(current_department, params).order(id: :desc)
    end
    respond_to do |format|
      format.html
      format.js
      format.xls do
        render xls: 'Employee List', layout: 'excel', template: 'employees/employee_list_xls_doc.html.erb', encoding: 'utf-8'
      end
      format.pdf do
        render pdf: 'Employee List', layout: 'pdf', template: 'employees/employee_list_pdf.html.erb', encoding: 'utf-8'
      end
      format.docx do
        render docx: 'Employee List', layout: 'document', template: 'employees/employee_list_xls_doc.html.erb', encoding: 'utf-8'
      end
    end
  end

  def attendances
    @employee = Employee.friendly.find(params[:employee_id]) || current_employee
    start_date = Date.today.beginning_of_month
    end_date = Date.today
    if params[:daterange].present?
      date_range = params[:daterange].split('To')
      start_date = format_string_date(date_range.first)
      end_date = format_string_date(date_range.last)
    end
    @attendances = @employee.attendances.where(in_date: start_date..end_date).order(id: :desc)
    respond_to do |format|
      format.html
      format.js {
        @attendances = @employee.attendances.where(in_date: start_date..end_date).order(id: :desc)
        @todays_attendances = todays_attendances(@employee)
      }
      format.xls do
        render xls: 'Employee Attendances', layout: 'excel', template: 'employees/attendances_xls_docx.html.erb', encoding: 'utf-8'
      end
      format.pdf do
        render pdf: 'Employee Attendances', layout: 'pdf', template: 'employees/attendances_pdf.html.erb', encoding: 'utf-8'
      end
      format.docx do
        render docx: 'Employee Attendances', layout: 'document', template: 'employees/attendances_xls_docx.html.erb', encoding: 'utf-8'
      end
    end
  end

  def add
    @employee = Employee.new(employee_params)
    @employee.password = generate_password
    respond_to do |format|
      if @employee.save
        unless params[:employee_account].present?
          @employee.send_reset_password_instructions
        end
        format.html { redirect_to :back, notice: "Employee has been successfully created" }
        format.js
      else
        format.html { redirect_to :back, notice: "Employee creation failed" }
        format.js
      end
    end
  end

  def show
    @designations = @employee.department.designations
    respond_to do |format|
      format.js
      format.html
    end
  end

  def identity_attachment
    uploaded_attachment = Employee.find_by_id(params[:id]).attachment
    send_file uploaded_attachment.path,
              :filename => uploaded_attachment,
              :type => uploaded_attachment,
              :disposition => 'attachment'

  end

  def profile
    @employee = current_department.employees.find(params[:employee_id]) rescue nil
    respond_to do |format|
      format.js {}
    end
  end

  def card
    @employee = current_department.employees.friendly.find(params[:employee_id])
    barcode = Barby::Code128B.new(@employee.id_card_no).to_png(margin: 2, height: 18, width: 335)
    @barcode_image = Base64.encode64(barcode.to_s).gsub(/\s+/, "")
  end

  def edit
    @designations = @employee.department.designations
    unless @employee.access_right.present?
      access_right = @employee.build_access_right
      access_right.save
    end
    (@employee.department.payroll_categories.all - @employee.payroll_categories).each do |category|
      @employee.payroll_employee_categories.build(category_id: category.id)
    end
    respond_to do |format|
      format.html do
        @edit_modal = true
        render :show
      end
      format.js
    end
  end

  def settings
    @employee = Employee.friendly.find(params[:employee_id]) || current_employee
    @view = 'employees/passwords/update_password'
    render :show
  end

  def update_info
    respond_to do |format|
      if @employee.update_attributes(employee_params)
        @employee.remove_empty_payroll_category(params[:employee][:payroll_employee_categories_attributes]) if params[:employee][:payroll_employee_categories_attributes].present?
        format.html { redirect_to @employee, notice: 'Successfully updated' }
        format.js
        format.json { render json: @employee }
      else
        format.html { redirect_to :back, notice: "Couldn't be updated" }
        format.js
        format.json { render json: @employee.errors }
      end
    end

  end

  def destroy
    respond_to do |format|
      if @employee == current_employee
        format.html { redirect_to :back, notice: "You are deleting yourself. Isn't it hard!!!!???" }
        format.json { head :no_content }
        format.js
      else
        @employee.update(is_active: false, deactivated_by: current_employee.id, deactivate_date: Date.today)
        format.html { redirect_to :back, notice: "Successfully deleted" }
        format.json { head :no_content }
        format.js
      end
    end
  end


  def activation
    respond_to do |format|
      @employee.update(is_active: true, deactivate_date: nil)
      format.html { redirect_to :back, notice: "Successfully activated" }
      format.json { head :no_content }
      format.js
    end
  end


  def confimed_email_error

  end

  def access_rights
    if params[:department_id].present?
      @employees = Employee.all.where(department_id: params[:department_id])
    else
      @employees = current_department.employees
    end
    if params[:employee_id].present?
      @employee = Employee.find_by_id(params[:employee_id])
    else
      @employee = current_employee
    end

    if @employee.access_right.present?
      @access_right = @employee.access_right
    else
      @access_right = @employee.build_access_right
      @access_right.save
    end
  end

  def update_password
    @employee = Employee.find(current_employee.id)
    respond_to do |format|
      if @employee.update_with_password(employee_params)
        sign_out @employee
        format.html { redirect_to new_employee_session_path, success: 'Password hes been changed. Please Login with new password.' }
      else
        format.html { redirect_to :back, danger: "#{ errors_to_message_string(@employee.errors) }" }
      end
    end
  end


  def import
    respond_to do |format|
      if params[:file].present?
        if params[:file].path.downcase.end_with?('.xlsx')
          s_header = ["FirstName", "LastName", "Email", "EmployeeId", "Designation", "BasicSalary", "JoiningDate", "NationalId", "Country", "Gender", "BloodGroup", "Dateofbirth", "MaritalStatus", "Mobile", "PresentAddress", "PermanentAddress", "KinName", "KinContact", "BankAccountNumber", "BankDetails", "PriviousEmploymentHistory", "Nationality", "Religion"]

          begin
            spreadsheet = Roo::Spreadsheet.open(params[:file].path)
            header = spreadsheet.row(1)
          rescue NoMethodError => err
            respond_to do |format|
              format.html { redirect_to :back, notice: " This file is not containing valid employee information. check the file" }
            end
          end

          missing_column_name = false

          (0..s_header.length).each do |column_no|
            unless header[column_no] == s_header[column_no]
              missing_column_name = true
            end
          end

          missing_column_value = false

          (2..spreadsheet.last_row).each do |i|
            row = Hash[[header, spreadsheet.row(i)].transpose]
            if row['FirstName'].blank? || row['LastName'].blank? || row['Email'].blank? || row['EmployeeId'].blank? || row['BasicSalary'].blank? || row['Mobile'].blank? || row['PresentAddress'].blank? || row['PermanentAddress'].blank?
              missing_column_value = true
            end
          end

          if missing_column_name.present?
            format.html { redirect_to :back, notice: "Invalid file format; Please download the template and follow it" }

          elsif missing_column_value.present?
            format.html { redirect_to :back, notice: " Please check carefully what you have missed (First Name, last Name, Email, Employee Id, Basic Salary, Mobile, Present Address, Permanent Address  which can not be empty)." }

          else
            response = Employee.import(spreadsheet, header, @cur_department)
            false_count = response.collect { |rs| rs[:status] unless rs[:status] == true }.count
            message = employee_import_message_generator(response, false_count)
            format.html { redirect_to :back, notice: "Employee has been successfully created. #{ '<b/r>' + message if false_count > 0 }" }
          end

        else
          format.html { redirect_to :back, notice: "Invalid file selected.Download the template/select a valid excel file and try again" }
        end

      else
        format.html { redirect_to :back, notice: "File not selected; Select and Upload a valid file and try again" }
      end
    end
  end

  def download_templete
    send_file(Rails.root.join('public', 'employee_templete.xlsx'), :type => "application/xlsx", :x_sendfile => true)
  end

  def payroll_categories
  end

  def increments
  end

  private

  def generate_password
    # o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    # string = (0...50).map { o[rand(o.length)] }.join
    "123456789"
  end

  def set_employee
    employee_searched = Employee.friendly.find(params[:id])
    if employee_searched.present? && employee_searched.department.company == current_department.company
      @employee = employee_searched
    else
      redirect_to employee_path(current_employee)
    end
  end


  def employee_params
    params.require(:employee).permit!
  end
end
