# == Schema Information
#
# Table name: designations
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  description   :text(65535)
#  is_active     :boolean          default(FALSE)
#  department_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe DesignationsController, type: :controller do
  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id: @company.id)
    @designation = FactoryGirl.create(:designation, department_id: @department.id)
    @designation_two = FactoryGirl.create(:designation, name: 'Software Engineer', department_id: @department.id)
    @employee = FactoryGirl.create(:employee, role:Employee::ROLE[:admin], department_id: @department.id, designation_id: @designation_two.id)
    session[:department_id] = @department.id
    sign_in(@employee)
  end

  describe 'get#show' do
    it 'should request to Show action' do
      xhr 'get', 'show', id: @designation.id, format: :js
      expect(response).to be_success
      expect(assigns(:designation)).to eq(@designation)
    end
  end

  describe 'get#new' do
    context 'when department params present' do
      it 'should request to DesignationsController new without department params' do
        get :new
        expect(response).to be_success
      end
    end
    context 'When department params not present' do
      it 'should request to DesignationsController new with department params' do
        get :new, department: @department
        expect(response).to be_success
      end
    end
  end

  describe 'post#create' do
    context 'when department_id params not present' do
      it 'should request to DesignationsController create without department_id' do
        request.env["HTTP_REFERER"] = department_path(@department.id)
        post :create, designation: {name: Faker::Company.profession, description: Faker::Lorem.sentences, is_active: true, department_id: @department.id}
        expect(response).to redirect_to(department_path(@department.id))
      end
      it 'should request to DesignationsController create without department_id as js format' do
        xhr :post, :create, format: :js, designation: {name: Faker::Company.profession, description: Faker::Lorem.sentences, is_active: true, department_id: @department.id}
        expect(response).to be_success
      end
    end
    context 'when department_id params present' do
      it 'should request to DesignationsController create with department_id' do
        request.env["HTTP_REFERER"] = department_path(@department.id)
        post :create, department_id: @department.id, designation: {name: Faker::Company.profession, description: Faker::Lorem.sentences, is_active: true, department_id: @department.id}
        expect(response).to redirect_to(department_path(@department.id))
      end
      it 'should request to DesignationsController create with department_id' do
        xhr :post, :create, format: :js, department_id: @department.id, designation: {name: Faker::Company.profession, description: Faker::Lorem.sentences, is_active: true, department_id: @department.id}
        expect(response).to be_success
      end
    end
    it 'should request to DesignationsController create with department_id but not saved' do
      post :create, department_id: @department.id, designation: {name: @designation.name, description: Faker::Lorem.sentences, is_active: true, department_id: @department.id}
      expect(response).to be_success
      expect(assigns(:designation).errors.full_messages.first).to eq("Name has already been taken")
    end
  end

  describe 'get#edit' do
    it 'should request to DesignationsController edit' do
      xhr 'get', 'edit', id: @designation.id, format: :js
      expect(response).to be_success
      expect(assigns(:designation)).to eq @designation
    end
  end

  describe 'put#update' do
    context 'when updated' do
      it 'should request to DesignationsController update' do
        put :update, id: @designation.id, designation: {description: Faker::Lorem.sentences, is_active: true, department_id: @department.id}
        expect(response).to redirect_to(@designation)
      end
    end
    context 'When not updated' do
        it 'should request to DesignationsController update but not updated' do
          put :update, id: @designation.id, designation: {name: @designation_two.name}
          expect(response).to be_success
          expect(assigns(:designation).errors.full_messages.first).to eq("Name has already been taken")
        end
    end
  end

 describe 'delete#destroy' do
   context 'When deleted' do
     it 'should request to DesignationsController destroy' do
       request.env["HTTP_REFERER"] = department_path(@department.id)
       count = Designation.all.count
       delete :destroy, id: @designation.id
       expect(Designation.all.count).to eq(count - 1)
       expect(response).to redirect_to(department_path(@department.id))
     end
   end
   context 'When not deleted' do
       it 'should request to DesignationsController not destroy' do
         request.env["HTTP_REFERER"] = department_path(@department.id)
         delete :destroy, id: @designation_two.id
        # expect(assigns(:designation).errors.full_messages.first).to eq("Cannot delete designation as used employee's designation")
         expect(response).to redirect_to(department_path(@department.id))
       end
     end
   end
 end
