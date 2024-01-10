require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id:@company.id)
    @employee = FactoryGirl.create(:employee, role:Employee::ROLE[:admin], department_id:@department.id)
    session[:department_id] = @department.id
    sign_in(@employee)
  end

  describe 'HomeController get#index' do
    it 'should return response successful' do
      get :index
      expect(response).to be_success
    end
  end

  describe 'get#submit_contact' do
    context ' if @contact_us.save' do
      it 'should request to submit_contact' do
        get :submit_contact, contact_us: {name:'arif', email:'arif@gmail.com'}
        expect(response).to redirect_to(root_path)
      end
    end
    context 'if @contact_us not saved' do
      it 'should request to submit_contact' do
        get :submit_contact, contact_us: {name:'arif'}
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'get # email_subscribe' do
    it 'should request to email_subscribe' do
      xhr :get, :email_subscribe, format: :js, subscription: {email:'arif@gmail.com'}
      expect(response).to be_success
    end
  end




end
