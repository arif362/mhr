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

require 'rails_helper'
require 'faker'

RSpec.describe Leave::ApplicationsController, type: :controller do

  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id: @company.id)
    @employee = FactoryGirl.create(:employee, role: Employee::ROLE[:admin], department_id: @department.id)
    @employee_1 = FactoryGirl.create(:employee, role: Employee::ROLE[:admin], department_id: @department.id)
    @leave_category = FactoryGirl.create(:leave_category, department_id: @department.id)
    @leave_application = FactoryGirl.create(:leave_application, department_id: @department.id, employee_id: @employee.id, leave_category_id: @leave_category.id, is_approved: true, status: AppSettings::STATUS[:approved])
    @leave_day = FactoryGirl.create(:leave_days, leave_application_id: @leave_application.id)
    @access_right = FactoryGirl.create(:access_right, employee_id: @employee.id)
    session[:department_id] = @department.id
    sign_in(@employee)
  end

  describe 'get#index' do
    context 'if parameter q present as params' do
      it 'should request to index action of Leave ApplicationController' do
        start_time = Date.today.at_beginning_of_year
        end_time = start_time.at_end_of_year
        @leave_applications = @department.leave_applications.where(status: 'abc', created_at: start_time..end_time).order(id: :desc)
        get :index, q: 'abc'
        expect(response).to be_success
        expect(assigns(:leave_applications)).to eq(@leave_applications)
      end
      it 'should request to index action of Leave ApplicationController as js' do
        start_time = 1.year.ago
        end_time = start_time.at_end_of_year
        @leave_applications = @department.leave_applications.where(status: 'dfg', created_at: start_time..end_time).order(id: :desc)
        xhr :get, :index, format: :js, q: 'dfg'
        expect(response).to be_success
        expect(assigns(:leave_applications)).to eq(@leave_applications)
      end
    end
    context 'if parameter q not present as params' do
      it 'should request to index action of Leave ApplicationController' do
        get :index
        expect(response).to be_success
      end
      it 'should request to index action of Leave ApplicationController as js' do
        xhr :get, :index, format: :js
        expect(response).to be_success
      end
    end
  end

  describe 'get#leave_status' do
    it 'should request to leave_status action of Leave ApplicationController' do
      get :leave_status, employee_id: @employee.id
      expect(response).to be_success
    end
    it 'should request to leave_status action of Leave ApplicationController as js format' do
      xhr :get, :leave_status, format: :js, employee_id: @employee.id
      expect(response).to be_success
    end
  end

  describe 'get#employee_status' do
    context 'if params[:employee_id] present?' do
      it 'should request to leave_status action of Leave ApplicationController ' do
        year = Date.today.year
        @result = Leave::Application.employee_status(@department, @employee_1, year)
        get :employee_status, employee_id: @employee_1.id
        expect(response).to be_success
        expect(assigns(:employee)).to eq(@department.employees.find_by_id(@employee_1.id))
        expect(assigns(:employee)).to eq(@employee_1)
        expect(assigns(:result)).to eq(@result)
      end
      it 'should request to leave_status action of Leave ApplicationController as xls' do
        year = Date.today.year
        @result = Leave::Application.employee_status(@department, @employee_1, year)
        xhr :get, :employee_status, format: :xls, employee_id: @employee_1.id
        expect(response).to be_success
        expect(assigns(:employee)).to eq(@department.employees.find_by_id(@employee_1.id))
        expect(assigns(:employee)).to eq(@employee_1)
        expect(assigns(:result)).to eq(@result)
        expect(response).to render_template('leave/applications/employee_status_xls_docx.html.erb')
      end
      it 'should request to leave_status action of Leave ApplicationController as pdf' do
        year = Date.today.year
        @result = Leave::Application.employee_status(@department, @employee_1, year)
        xhr :get, :employee_status, format: :pdf, employee_id: @employee_1.id
        expect(response).to be_success
        expect(assigns(:employee)).to eq(@department.employees.find_by_id(@employee_1.id))
        expect(assigns(:employee)).to eq(@employee_1)
        expect(assigns(:result)).to eq(@result)
        expect(response).to render_template('leave/applications/employee_status_pdf.html.erb')
      end
      it 'should request to leave_status action of Leave ApplicationController as docx' do
        year = Date.today.year
        @result = Leave::Application.employee_status(@department, @employee_1, year)
        xhr :get, :employee_status, format: :docx, employee_id: @employee_1.id
        expect(response).to be_success
        expect(assigns(:employee)).to eq(@department.employees.find_by_id(@employee_1.id))
        expect(assigns(:employee)).to eq(@employee_1)
        expect(assigns(:result)).to eq(@result)
        expect(response).to render_template('leave/applications/employee_status_xls_docx.html.erb')
      end
    end
    context 'if params[:employee_id] not present?' do
      it 'should request to leave_status action of Leave ApplicationController ' do
        year = Date.today.year
        @result = Leave::Application.employee_status(@department, @employee_1, year)
        get :employee_status
        expect(response).to be_success
        expect(assigns(:employee)).to eq(@employee)
        expect(assigns(:employee)).to eq(@department.employees.find_by_id(@employee.id))
        expect(assigns(:employee)).to eq(@employee)
        expect(assigns(:result)).to eq(@result)
      end
      it 'should request to leave_status action of Leave ApplicationController as docx' do
        year = Date.today.year
        @result = Leave::Application.employee_status(@department, @employee_1, year)
        xhr :get, :employee_status, format: :docx
        expect(response).to be_success
        expect(assigns(:employee)).to eq(@department.employees.find_by_id(@employee.id))
        expect(assigns(:employee)).to eq(@employee)
        expect(assigns(:result)).to eq(@result)
        expect(response).to render_template('leave/applications/employee_status_xls_docx.html.erb')

      end
      it 'should request to leave_status action of Leave ApplicationController as xls' do
        year = Date.today.year
        @result = Leave::Application.employee_status(@department, @employee_1, year)
        xhr :get, :employee_status, format: :xls
        expect(response).to be_success
        expect(assigns(:employee)).to eq(@department.employees.find_by_id(@employee.id))
        expect(assigns(:employee)).to eq(@employee)
        expect(assigns(:result)).to eq(@result)
        expect(response).to render_template('leave/applications/employee_status_xls_docx.html.erb')
      end
      it 'should request to leave_status action of Leave ApplicationController as pdf' do
        year = Date.today.year
        @result = Leave::Application.employee_status(@department, @employee_1, year)
        xhr :get, :employee_status, format: :pdf
        expect(response).to be_success
        expect(assigns(:employee)).to eq(@department.employees.find_by_id(@employee.id))
        expect(assigns(:employee)).to eq(@employee)
        expect(assigns(:result)).to eq(@result)
        expect(response).to render_template('leave/applications/employee_status_pdf.html.erb')
      end
    end
  end

  describe 'get#show' do
    it 'should request to show action of Leave ApplicationController' do
      taken_days = @leave_application.leave_category.leave_applications.where(is_approved: true, is_paid: true, employee_id: @leave_application.employee_id).sum(:total_days)
      year = Date.today.year
      @remain = @leave_application.leave_category.days(@leave_application.created_at.year) - taken_days
      get :show, id: @leave_application.id
      expect(response).to be_success
      expect(assigns(:remain)).to eq(@remain)
    end
    it 'should request to show action of Leave ApplicationController' do
      taken_days = @leave_application.leave_category.leave_applications.where(is_approved: true, is_paid: true, employee_id: @leave_application.employee_id).sum(:total_days)
      year = Date.today.year
      @remain = @leave_application.leave_category.days(@leave_application.created_at.year) - taken_days
      xhr :get, :show, format: :js, id: @leave_application.id
      expect(response).to be_success
      expect(assigns(:remain)).to eq(@remain)
    end
  end

  describe 'get#download' do
    it 'should request to download action of Leave ApplicationController' do
      xhr :get, :download, format: :pdf, id: @leave_application.id
      expect(response).to render_template('leave/applications/application_pdf.html.erb')
    end
  end

  describe 'get#new' do
    it 'should request to new action of Leave ApplicationController' do
      @leave_categories = @department.leave_categories.active
      get :new, employee: @employee.id
      expect(response).to be_success
      expect(assigns(:leave_application)).to be_a_new(Leave::Application)
      expect(assigns(:leave_categories)).to eq(@leave_categories)
    end
    it 'should request to new action of Leave ApplicationController' do
      @leave_categories = @department.leave_categories.active
      xhr :get, :new, format: :js, employee: @employee.id
      expect(response).to be_success
      expect(assigns(:leave_application)).to be_a_new(Leave::Application)
      expect(assigns(:leave_categories)).to eq(@leave_categories)
    end
  end

  describe 'get#edit' do
    it 'should request to edit action of Leave ApplicationController' do
      get :edit, id: @leave_application.id
      expect(response).to be_success
    end
  end

  # describe 'post#create' do
  #   it 'should request to create action of Leave ApplicationController' do
  #     post :create, leave_days: Faker::Date.forward(5), leave_application: {message: Faker::Lorem.paragraph}
  #     expect(response).to render_template(:new)
  #   end
  # end

  # describe 'put#update' do
  #   it 'should request to update action of Leave ApplicationController' do
  #     put :update, id: @leave_application.id, leave_application: {status: AppSettings::STATUS[:approved]}
  #     expect(response).to redirect_to(@leave_application)
  #   end
  # end

  describe 'get#reject_application' do
    it 'should request to reject_application action of Leave ApplicationController' do
      xhr :get, :reject_application, format: :js, id: @leave_application.id, leave_application: {is_approved: false, status: AppSettings::STATUS[:rejected]}
      expect(response).to be_success
    end
  end

  describe 'delete#destroy' do
    it 'should request to destroy action of Leave ApplicationController' do
      delete :destroy, id: @leave_application.id
      expect(response).to redirect_to(leave_applications_url)
    end
    it 'should request to destroy action of Leave ApplicationController as js format' do
      xhr :delete, :destroy, format: :js, id: @leave_application.id
      expect(response).to be_success
    end
  end

  describe 'get#report' do
    it 'should request to report action of Leave ApplicationController' do
      get :report
      expect(response).to be_success
    end
    it 'should request to report action of Leave ApplicationController' do
      xhr :get, :report, format: :js
      expect(response).to be_success
    end
  end

  describe 'get#summary' do
    it 'should request to summary action of Leave ApplicationController' do
      get :summary
      expect(response).to be_success
    end
    it 'should request to summary action of Leave ApplicationController as xls format' do
      xhr :get, :summary, format: :xls
      expect(response).to render_template('leave/applications/summary_xls_docx.html.erb')
    end
    it 'should request to summary action of Leave ApplicationController as pdf format' do
      xhr :get, :summary, format: :pdf
      expect(response).to render_template('leave/applications/summary_pdf.html.erb')
    end
    it 'should request to summary action of Leave ApplicationController as docx format' do
      xhr :get, :summary, format: :docx
      expect(response).to render_template('leave/applications/summary_xls_docx.html.erb')
    end
  end

  describe 'get#leave_calendar' do
    it 'should request to leave_calendar action of Leave ApplicationController' do
      get :leave_calendar
      expect(response).to be_success
      expect(assigns(:leave_applications)).to eq([@leave_application])
    end
  end

  # before(:each) do
  #   @company = FactoryGirl.create(:company)
  #   @department = FactoryGirl.create(:department, company_id: @company.id)
  #   @employee = FactoryGirl.create(:employee, department_id: @department.id)
  #   @access_right_admin = FactoryGirl.create(:access_right, employee_id: @employee.id)
  #   @leave_category = FactoryGirl.create(:leave_category,department_id: @department.id)
  #   @leave_application = FactoryGirl.create(:leave_application, department_id:@department.id, employee_id: @employee.id, leave_category_id: @leave_category.id, status: AppSettings::STATUS[:pending])
  #   @leave_application1 = FactoryGirl.create(:leave_application, department_id:@department.id, employee_id: @employee.id, leave_category_id: @leave_category.id, is_approved: true,status: AppSettings::STATUS[:approved])
  #   @leave_day1 = FactoryGirl.create(:leave_days, leave_application_id: @leave_application.id)
  #   @leave_day2 = FactoryGirl.create(:leave_days, leave_application_id: @leave_application.id)
  #   @leave_day3 = FactoryGirl.create(:leave_days, leave_application_id: @leave_application.id)
  #   session[:department_id] = @department.id
  #   sign_in(@employee)
  # end

  let(:valid_attributes) {
    {
        'message' => Faker::Lorem.paragraph,
        'is_approved' => true,
        'employee_id' => @employee.id,
        'leave_category_id' => @leave_category.id,
        'department_id' => @department.id
    }
  }
  let(:leave_days) {
    "#{Faker::Date.forward(5)},#{Faker::Date.forward(5)},#{Faker::Date.forward(5)},#{Faker::Date.forward(5)},#{Faker::Date.forward(5)},#{Faker::Date.forward(5)}"
  }

  let(:invalid_attributes) {
    {
        'employee_id' => '',
        'leave_category_id' => '',
        'message' => Faker::Lorem.paragraph,
        'is_approved' => false
    }
  }


  # describe "GET #index" do
  #   it "assigns all applications as @leave_applications for http call" do
  #     get :index, params: {}
  #     expect(response).to be_success
  #     expect(assigns(:leave_applications)).to eq([@leave_application1])
  #   end
  #   it "assigns all applications as @leave_applications for http call with date range params" do
  #     get :index, date_range: Date.today.beginning_of_year.to_s + ' To ' + Date.today.end_of_year.to_s
  #     expect(response).to be_success
  #     expect(assigns(:leave_applications)).to eq([@leave_application1])
  #   end
  #   it "assigns all applications as @leave_applications for ajax call" do
  #     xhr :get, :index, params: {}, format: :js
  #     expect(response).to be_success
  #     expect(assigns(:leave_applications)).to eq([@leave_application1])
  #   end
  # end
  #
  # describe "GET #status" do
  #   it "assigns all current_employee leave_application to @leave_applications for http call" do
  #     get :leave_status, employee_id: @employee.id
  #     expect(response).to be_success
  #     expect(assigns(:leave_applications)).to eq([@leave_application, @leave_application1])
  #     expect(assigns(:leave_categories)).to eq([@leave_category])
  #   end
  #   it "assigns all current_employee leave_application to @leave_applications for http call with year date params" do
  #     get :leave_status, employee_id: @employee.id, date: {year: Date.today.year}
  #     expect(response).to be_success
  #     expect(assigns(:leave_applications)).to eq([@leave_application, @leave_application1])
  #     expect(assigns(:leave_categories)).to eq([@leave_category])
  #   end
  #   it "assigns all current_employee leave_application to @leave_applications for ajax call" do
  #     xhr :get, :leave_status, employee_id: @employee.id, format: :js
  #     expect(response).to be_success
  #     expect(assigns(:leave_applications)).to eq([@leave_application, @leave_application1])
  #     expect(assigns(:leave_categories)).to eq([@leave_category])
  #   end
  #
  # end
  #
  # describe "GET #show" do
  #   it "assigns the requested leave_application as @leave_application  for http call" do
  #     get :show, id: @leave_application.to_param
  #     expect(response).to be_success
  #     expect(assigns(:leave_application)).to eq(@leave_application)
  #   end
  #   it "assigns the requested leave_application as @leave_application for ajax call" do
  #     xhr :get, :show, id: @leave_application.to_param, format: :js
  #     expect(response).to be_success
  #     expect(assigns(:leave_application)).to eq(@leave_application)
  #   end
  # end
  #
  # describe "GET #new" do
  #   it "assigns a new leave_application as @leave_application for http" do
  #     get :new
  #     expect(response).to be_success
  #     expect(assigns(:leave_application)).to be_a_new(Leave::Application)
  #   end
  #   it "assigns a new leave_application as @leave_application for ajax" do
  #     xhr :get, :new, format: :js
  #     expect(response).to be_success
  #     expect(assigns(:leave_application)).to be_a_new(Leave::Application)
  #   end
  # end
  #
  # describe "GET #edit" do
  #   it "assigns the requested leave_application as @leave_application" do
  #     get :edit, id: @leave_application.to_param
  #     expect(response).to be_success
  #     expect(assigns(:leave_application)).to eq(@leave_application)
  #   end
  #   it "assigns the requested leave_application as @leave_application for ajax" do
  #     xhr :get, :edit, id: @leave_application.to_param, format: :js
  #     expect(response).to be_success
  #     expect(assigns(:leave_application)).to eq(@leave_application)
  #   end
  # end
  #
  describe "POST #create" do
    context "with valid params" do
      it "creates a new Leave::Application" do
        expect {
          post :create, leave_application: valid_attributes, leave_days: leave_days
        }.to change(Leave::Application, :count).by(1)
      end

      it "assigns a newly created leave_application as @leave_application" do
        post :create, leave_application: valid_attributes, leave_days: leave_days
        expect(assigns(:leave_application)).to be_a(Leave::Application)
        expect(assigns(:leave_application)).to be_persisted
      end
      it "assigns a newly created leave_application as @leave_application for ajax" do
        xhr :post, :create, leave_application: valid_attributes, leave_days: leave_days, format: :js
        expect(response).to be_success
        expect(assigns(:leave_application)).to be_a(Leave::Application)
      end

      it "redirects to the created leave_application" do
        post :create, leave_application: valid_attributes, leave_days: leave_days
        expect(response).to redirect_to(Leave::Application.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved leave_application as @leave_application" do
        post :create, leave_application: invalid_attributes, leave_days: leave_days
        expect(assigns(:leave_application)).to be_a_new(Leave::Application)
      end
      it "re-renders the 'new' template" do
        post :create, leave_application: invalid_attributes, leave_days: leave_days
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {
            'message' => Faker::Lorem.paragraph,
            'is_approved' => true,
            'employee_id' => @employee.id,
            'leave_category_id' => @leave_category.id
        }
      }

      let(:new_attributes_not_approved) {
        {
            'message' => Faker::Lorem.paragraph,
            'is_approved' => false,
            'employee_id' => @employee.id,
            'leave_category_id' => @leave_category.id
        }
      }

      let(:new_leave_days) {
        [
            {'id' => @leave_day1.id, 'is_approved' => false},
            {'id' => @leave_day2.id, 'is_approved' => true},
            {'id' => @leave_day3.id, 'is_approved' => true}
        ]
      }
      let(:new_leave_days2) {
        [
            {'id' => @leave_day1.id, 'is_approved' => true},
            {'id' => @leave_day2.id, 'is_approved' => true},
            {'id' => @leave_day3.id, 'is_approved' => true}
        ]
      }

      # it "updates the requested leave_application" do
      #   put :update, id: @leave_application.to_param, leave_application: new_attributes, leave_days: new_leave_days
      #   @leave_application.reload
      # end
      #
      # it "updates the requested leave_application with not approved false params" do
      #   put :update, id: @leave_application.to_param, leave_application: new_attributes_not_approved, leave_days: new_leave_days
      #   @leave_application.reload
      # end
      #
      # it "assigns the requested leave_application as @leave_application with leave days" do
      #   put :update, id: @leave_application.to_param, leave_application: valid_attributes, leave_days: new_leave_days
      #   expect(assigns(:leave_application)).to eq(@leave_application)
      # end
      it "assigns the requested leave_application as @leave_application without leave days" do
        put :update, id: @leave_application.to_param, leave_application: valid_attributes
        expect(assigns(:leave_application)).to eq(@leave_application)
      end

      # it "assigns the requested leave_application as @leave_application with leave days for ajax call" do
      #   xhr :put, :update, id: @leave_application.to_param, leave_application: valid_attributes, format: :js
      #   expect(assigns(:leave_application).total_days).to eq 3
      # end

      it "redirects to the leave_application" do
        put :update, id: @leave_application.to_param, leave_application: valid_attributes
        expect(response).to redirect_to(@leave_application)
      end
    end

    context "with invalid params" do
      it "assigns the leave_application as @leave_application" do
        put :update, id: @leave_application.to_param, leave_application: invalid_attributes
        expect(assigns(:leave_application)).to eq(@leave_application)
      end

      it "re-renders the 'edit' template" do
        put :update, id: @leave_application.to_param, leave_application: invalid_attributes
        expect(response).to be_success
      end
    end
  end

  # describe "DELETE #destroy" do
  #   it "destroys the requested leave_application" do
  #     expect {
  #       delete :destroy, id: @leave_application.to_param
  #     }.to change(Leave::Application, :count).by(-1)
  #   end
  #
  #   it "destroys the requested leave_application" do
  #     expect {
  #       xhr :delete, :destroy, id: @leave_application.to_param, format: :js
  #     }.to change(Leave::Application, :count).by(-1)
  #   end
  #
  #   it "redirects to the applications list" do
  #     delete :destroy, id: @leave_application.to_param
  #     expect(response).to redirect_to(leave_applications_url)
  #   end
  # end
  #
  # describe 'GET #reject_application' do
  #   it "should reject a leave application" do
  #     xhr :get, :reject_application, id: @leave_application.id, format: :js
  #     expect(response).to be_success
  #     expect(assigns(:leave_application).is_approved).to eq(false)
  #     expect(assigns(:leave_days)).to eq([@leave_day1, @leave_day2, @leave_day3])
  #     expect(assigns(:leave_days).first.is_approved).to eq(false)
  #   end
  # end
  #
  # describe 'GET #report' do
  #   it "should return recent and yearly leave days" do
  #     get :report
  #     expect(response).to be_success
  #     expect(assigns(:recent_leave_days)).to eq([]) # TODO: need to check these later
  #     expect(assigns(:leave_days_in_a_year)).to eq([])
  #   end
  #   it "should return recent leave days as PDF" do
  #     xhr :get, :report, is_recent: true, format: :pdf
  #     expect(response).to be_success
  #   end
  #   it "should return yearly leave days as PDF" do
  #     xhr :get, :report, format: :pdf
  #     expect(response).to be_success
  #   end
  #   it "should return recent leave days as DOCX" do
  #     xhr :get, :report, is_recent: true, format: :docx
  #     expect(response).to be_success
  #   end
  #   it "should return yearly leave days as DOCX" do
  #     xhr :get, :report, format: :docx
  #     expect(response).to be_success
  #   end
  # end
  #
  # describe 'GET #summary' do
  #   it "should return summary leave report" do
  #     get :summary
  #     expect(response).to be_success
  #     expect(assigns(:leave_categories)).to eq([@leave_category])
  #   end
  #   it "should return summary leave report with year params" do
  #     get :summary, date: {year: Date.today.year}
  #     expect(response).to be_success
  #     expect(assigns(:leave_categories)).to eq([@leave_category])
  #   end
  #   it "should return summary leave report as PDF" do
  #     xhr :get, :summary, format: :pdf
  #     expect(response).to be_success
  #   end
  #   it "should return summary leave report as DOCX" do
  #     xhr :get, :summary, format: :docx
  #     expect(response).to be_success
  #   end
  # end
  #
  # describe 'GET #leave_calendar' do
  #   it "should return leave calender day offs" do
  #     get :leave_calendar
  #     expect(response).to be_success
  #     expect(assigns(:leave_applications)).to eq([@leave_application1])
  #   end
  # end
end
