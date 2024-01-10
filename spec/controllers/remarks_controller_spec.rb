# == Schema Information
#
# Table name: remarks
#
#  id              :integer          not null, primary key
#  message         :text(65535)
#  remarkable_id   :integer
#  remarkable_type :string(255)
#  is_seen         :boolean          default(FALSE)
#  is_admin        :boolean          default(TRUE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  remarked_by_id  :integer
#

require 'rails_helper'

RSpec.describe RemarksController, type: :controller do
  # before(:each) do
  #   @company = FactoryGirl.create(:company)
  #   @department =  FactoryGirl.create(:department, company_id: @company.id)
  #   @employee = FactoryGirl.create(:employee,role:Employee::ROLE[:admin], department_id: @department.id)
  #   @expense_category = FactoryGirl.create(:expenses_category, department_id: @department.id)
  #   @expense_sub_category = FactoryGirl.create(:expenses_category, department_id: @department.id, expense_category_id: @expense_category.id)
  #   @expense = FactoryGirl.create(:expenses_expense, department_id: @department.id, expense_category_id: @expense_category.id, expense_sub_category_id: @expense_sub_category.id, created_by_id: @employee.id)
  #   @remark_1 = FactoryGirl.create(:remark, remarkable_id: @expense.id, remarkable_type: @expense.class.name, remarked_by_id: @employee.id)
  #   @remark_2 = FactoryGirl.create(:remark, remarkable_id: @expense.id, remarkable_type: @expense.class.name, remarked_by_id: @employee.id)
  #   session[:department_id] = @department.id
  #   sign_in(@employee)
  # end
  #
  # describe 'GET #new' do
  #   it 'When class with module' do
  #     xhr :get, :new, remarkable_object: @expense.id, remarkable_type: @expense.class.name, format: :js
  #     expect(response).to be_success
  #     expect(assigns(:remark)).to be_a_new(Remark)
  #     expect(assigns(:remarkable_object)).to eq(@expense)
  #     expect(assigns(:remarks)).to eq([@remark_1, @remark_2])
  #   end
  # end
  #
  # describe 'POST #create' do
  #   it 'When class with module with valid params' do
  #     post :create, remarkable_object: @expense.id, remarkable_type: @expense.class.name, remark: {message: Faker::Lorem.sentences}
  #     expect(response).to redirect_to(expenses_expenses_path)
  #     expect(assigns(:remarkable_object)).to eq(@expense)
  #     expect(assigns(:remark)).to eq(@expense.remarks.last)
  #   end
  #
  #   it 'When class with module with invalid params' do
  #     post :create, remarkable_object: @expense.id, remarkable_type: @expense.class.name, remark: {message: ''}
  #     expect(response).to redirect_to(expenses_expenses_path)
  #     expect(assigns(:remark).errors.full_messages.last).to eq("Message can't be blank")
  #   end
  # end
end
