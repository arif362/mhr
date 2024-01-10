# == Schema Information
#
# Table name: employees_advances
#
#  id             :integer          not null, primary key
#  employee_id    :integer
#  amount         :float(24)
#  is_paid        :boolean          default(FALSE)
#  purpose        :text(65535)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  department_id  :integer
#  is_deactivated :boolean          default(FALSE)
#  is_completed   :boolean          default(FALSE)
#  installment    :float(24)
#  return_policy  :string(255)
#  date           :date
#

require 'rails_helper'
require 'faker'
RSpec.describe Employees::AdvancesController, type: :controller do

  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id:@company.id)
    @employee = FactoryGirl.create(:employee, role: Employee::ROLE[:admin], email:'arif@gmail.com', department_id:@department.id)
    @employees_advance = FactoryGirl.create(:employees_advance, employee_id:@employee.id, department_id:@department.id)
    session[:department_id] = @department.id
    sign_in(@employee)
  end

  describe 'get # index' do
    it 'should request to index' do
      get :index
      expect(response).to be_success
    end
    it 'should request to index' do
      get :index
      expect(assigns(:advances)).to eq([@employees_advance])
    end
    it 'should request to index as js' do
      xhr :get, :index, format: :js
      expect(response).to be_success
    end
    it 'should request to index as js' do
      xhr :get, :index, format: :js
      expect(assigns(:advances)).to eq([@employees_advance])
    end
    it 'should request to index as xls' do
      xhr :get, :index, format: :xls
      expect(response).to render_template('employees/advances/advance_list_xls_doc.html.erb')
    end
    it 'should request to index as pdf' do
      xhr :get, :index, format: :pdf
      expect(response).to render_template('employees/advances/advance_list_pdf.html.erb')
    end
    it 'should request to index as docx' do
      xhr :get, :index, format: :docx
      expect(response).to render_template('employees/advances/advance_list_xls_doc.html.erb')
    end
  end

  describe 'get # show' do
    it 'should request to show action' do
      get :show, id:@employees_advance
      expect(response).to be_success
    end
  end

  describe 'get # new' do
    it 'should request to new as js' do
      xhr :get, :new, format: :js
      expect(response).to be_success
    end
    it 'should assign a newly @advance' do
      xhr :get, :new, format: :js
      expect(assigns(:advance)).to be_a_new(Employees::Advance)
    end
  end

  describe 'post # create' do
    context 'if @advance save' do
      it 'should request to create action' do
        post :create, employees_advance: {employee_id:@employee.id,amount:40,date: Date.today}
        expect(response).to redirect_to(employees_advances_path)
      end
      it 'should increment a new advance' do
        count = Employees::Advance.count
        post :create, employees_advance: {employee_id:@employee.id,amount:40,date: Date.today}
        expect(Employees::Advance.count).to eq(count+1)
      end
    end
    context 'if @advance not save' do
      it 'should request to create action' do
        post :create, employees_advance: {amount:40,date: Date.today}
        expect(response).to redirect_to(employees_advances_path)
      end
    end
  end

  describe 'get # edit' do
    it 'should request to edit action' do
      xhr :get, :edit, format: :js, id:@employees_advance
      expect(response).to be_success
    end
  end

  describe 'put # update' do
    context 'when advance updated' do
      it 'should request to update action' do
        put :update,id:@employees_advance.id, employees_advance: {amount:40,date: Date.today}
        expect(response).to redirect_to(employees_advances_path)
      end
    end
    context 'when advance not updated' do
      it 'should request to update action' do
        put :update,id:@employees_advance.id, employees_advance: {amount:nil,date: Date.today}
        expect(response).to redirect_to(employees_advances_path)
      end
    end
  end

  describe 'delete # destroy' do
    context 'if @advance.destroy' do
      it 'should request to destroy action' do
        delete :destroy, id:@employees_advance.id
        expect(response).to redirect_to(employees_advances_path)
      end
    end
    ###### When will not delete advance have to be fixed #####
    # context 'if @advance not destroy' do
    #   it 'should request to destroy action' do
    #     delete :destroy, id :@employees_advance
    #     expect(response).to redirect_to(employees_advances_path)
    #   end
    # end

  end

  describe 'get # history' do
    it 'should request to history action' do
      get :history, employee_id:@employee.id
      expect(response).to be_success
    end
    it 'should request to xls template' do
      xhr :get, :history, format: :xls, employee_id:@employee.id
      expect(response).to render_template('employees/advances/history_xls_doc.html.erb')
    end
    it 'should request to pdf template' do
      xhr :get, :history, format: :pdf, employee_id:@employee.id
      expect(response).to render_template('employees/advances/history_pdf.html.erb')
    end
    it 'should request to pdf template' do
      xhr :get, :history, format: :docx, employee_id:@employee.id
      expect(response).to render_template('employees/advances/history_xls_doc.html.erb')
    end
  end

  describe 'get # employee_advances' do
    context 'when employee_id not present as params' do
      it 'should request to employee_advances' do
        xhr :get, :employee_advances, format: :js
        expect(response).to be_success
      end
    end
    context 'when employee_id present as params' do
      it 'should request to employee_advances' do
        xhr :get, :employee_advances, format: :js, employee_id:@employee.id
        expect(response).to be_success
      end
    end
  end

end
