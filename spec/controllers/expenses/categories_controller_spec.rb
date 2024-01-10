# == Schema Information
#
# Table name: expense_categories
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  description         :text(65535)
#  department_id       :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  expense_category_id :integer
#

require 'rails_helper'

RSpec.describe Expenses::CategoriesController, type: :controller do
  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id: @company.id)
    @employee = FactoryGirl.create(:employee, role: Employee::ROLE[:admin], department_id: @department.id)
    @expense_category = FactoryGirl.create(:expenses_category, department_id: @department.id)
    @expense_sub_category_1 = FactoryGirl.create(:expenses_category, name: 'lunce', department_id: @department.id, expense_category_id: @expense_category.id)
    #@expense_sub_category_2 = FactoryGirl.create(:expenses_category, department_id: @department.id, expense_category_id: @expense_category.id)
    # @expense_sub_category_3 = FactoryGirl.create(:expenses_category, department_id: @department.id, expense_category_id: @expense_category.id)
    session[:department_id] = @department.id
    sign_in(@employee)
  end
  let(:valid_attributes) {
    {
        name: Faker::Name.name,
        description: Faker::Lorem.sentences,
        department_id: @department.id
    }
  }
  let(:invalid_attributes) {
    {
        name: '',
        description: Faker::Lorem.sentences,
        department_id: @department.id
    }
  }

  describe 'GET #index' do
    it "should return all expenses of current department" do
      get :index
      expect(response).to be_success
      expect(assigns(:expense_categories).first.name).to eq(@expense_category.name)
      #expect(assigns(:expense_categories).first.expense_sub_categories.first.name).to eq(@expense_sub_category_1.name)
    end
  end

  describe 'GET #new' do
    it "should get new expense_category" do
      xhr :get, :new, format: :js
      expect(assigns(:expense_category)).to be_a_new(Expenses::Category)
    end
  end

  describe 'get#show' do
    it 'should request to show action of CategoriesController' do
      xhr :get, :show, format: :js, id: @expense_category.id
      expect(response).to be_success
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it "should create a new expense category" do
        xhr :post, :create, expenses_category: valid_attributes, format: :js
        expect(response).to be_success
        expect(assigns(:expense_category)).to eq(Expenses::Category.all_expense_categories(@department).last)
      end
    end
    context 'with invalid params' do
      it "should create a new expense category" do
        xhr :post, :create, expenses_category: invalid_attributes, format: :js
        expect(response).to be_success
        expect(assigns(:expense_category).errors.full_messages.first).to eq("Name can't be blank")
      end
    end
  end

  describe "GET #edit" do
    it "should assign expense category" do
      xhr :get, :edit, id: @expense_category.id, format: :js
      expect(assigns(:expense_category)).to eq(@expense_category)
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        {
            name: 'Rent'
        }
      }
      it "should update an expense category" do
        xhr :put, :update, id: @expense_category.id, expenses_category: new_attributes, format: :js
        expect(response).to be_success
        expect(assigns(:expense_category).name).to eq(new_attributes[:name])
      end
    end
    context 'with invalid params' do
      it "should not update the expense category" do
        xhr :put, :update, id: @expense_category.id, expenses_category: invalid_attributes, format: :js
        expect(response).to be_success
        expect(assigns(:expense_category).errors.full_messages.first).to eq("Name can't be blank")
      end
    end
  end

  describe "DELETE #destroy" do
    it "should destroy an expense category" do
      expect {
        delete :destroy, id: @expense_category.id, format: :js
      }.to change(Expenses::Category.all_expense_categories(@department), :count).by(-1)
    end
    it 'should destroy expense sub_category' do
      expect {
        delete :destroy, id: @expense_sub_category_1.id, format: :js
      }.to change(Expenses::Category.sub_categories_from_category(@expense_category.id), :count).by(-1)
    end
  end

  describe 'GET #sub_categories' do
    it "should return expense sub_categories" do
      xhr :get, :sub_categories, id: @expense_category.id, format: :js
      expect(assigns(:sub_categories)).to eq([@expense_sub_category_1])
    end
  end
end
