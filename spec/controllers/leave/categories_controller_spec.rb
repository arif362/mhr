# == Schema Information
#
# Table name: leave_categories
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  department_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  description   :text(65535)
#  is_active     :boolean          default(TRUE)
#

require 'rails_helper'

RSpec.describe Leave::CategoriesController, type: :controller do
  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id: @company.id)
    @employee = FactoryGirl.create(:employee, role: Employee::ROLE[:admin], department_id: @department.id)
    @access_right_admin = FactoryGirl.create(:access_right, employee_id: @employee.id)
    @leave_category = FactoryGirl.create(:leave_category, department_id: @department.id)
    session[:department_id] = @department.id
    sign_in(@employee)
  end

  let(:valid_attributes) {
    {
        'name' => 'sick'
    }
  }

  let(:invalid_attributes) {
    {
        'name' => ''
    }
  }

  describe "GET #new" do
    it "assigns a new leave_category as @leave_category" do
      xhr :get, :new, format: :js
      expect(response).to be_success
      expect(assigns(:leave_category)).to be_a_new(Leave::Category)
    end
  end

  describe 'get#show' do
    it 'should request to show action of leave categories controller' do
      xhr :get, :show, format: :js, id: @leave_category.id
      expect(response).to be_success
    end
  end

  describe "GET #edit" do
    it "assigns the requested leave_category as @leave_category" do
      xhr :get, :edit, id: @leave_category.id, format: :js
      expect(assigns(:leave_category)).to eq(@leave_category)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Leave::Category" do
        count = Leave::Category.count
        expect {
          xhr :post, :create, department_id: @department.id, leave_category: valid_attributes, format: :js
        }.to change(Leave::Category, :count).by(1)
        expect(Leave::Category.count).to eq(count+1)
      end

      it "assigns a newly created leave_category as @leave_category" do
        xhr :post, :create, department_id: @department.id, leave_category: valid_attributes, format: :js
        expect(assigns(:leave_category)).to be_a(Leave::Category)
        expect(assigns(:leave_category)).to be_persisted
      end

      it "redirects to the created leave_category" do
        xhr :post, :create, department_id: @department.id, leave_category: valid_attributes, format: :js
        expect(response).to be_success
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved leave_category as @leave_category for ajax" do
        xhr :post, :create, department_id: @department.id, leave_category: invalid_attributes, format: :js
        expect(assigns(:leave_category)).to be_a_new(Leave::Category)
        expect(assigns(:leave_category).errors.full_messages.first).to eq("Name can't be blank")
      end

      it "re-renders the 'new' template" do
        xhr :post, :create, department_id: @department.id, leave_category: invalid_attributes, format: :js
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {
            'name' => Faker::Name.name
        }
      }

      it "updates the requested leave_category" do
        xhr :put, :update, id: @leave_category.to_param, leave_category: new_attributes, format: :js
        @leave_category.reload
      end

      it "assigns the requested leave_category as @leave_category" do
        xhr :put, :update, id: @leave_category.to_param, leave_category: valid_attributes, format: :js
        expect(assigns(:leave_category)).to eq(@leave_category)
      end

      it "redirects to the leave_category" do
        xhr :put, :update, id: @leave_category.to_param, leave_category: valid_attributes, format: :js
        expect(response).to be_success
      end
    end

    context "with invalid params" do
      it "assigns the leave_category as @leave_category for ajax call" do
        xhr :put, :update, id: @leave_category.to_param, leave_category: invalid_attributes, format: :js
        expect(assigns(:leave_category)).to eq(@leave_category)
        expect(assigns(:leave_category).errors.full_messages.first).to eq("Name can't be blank")
      end

      it "re-renders the 'edit' template" do
        xhr :put, :update, id: @leave_category.to_param, leave_category: invalid_attributes, format: :js
        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested leave_category for ajax call" do
      expect {
        delete :destroy, id: @leave_category.to_param, format: :js
      }.to change(Leave::Category, :count).by(-1)
    end

    it "redirects to the categories list" do
      xhr :delete, :destroy, id: @leave_category.to_param, format: :js
      expect(response).to be_success
    end
  end

  describe 'get#activate' do
    it 'should request to activate action of categories_controller' do
      xhr :get, :activate, format: :js, id: @leave_category.to_param
      expect(response).to be_success
    end
  end

  describe 'get#deactivate' do
    it 'should request to activate action of categories_controller' do
      xhr :get, :deactivate, format: :js, id: @leave_category.to_param
      expect(response).to be_success
    end
  end
end
