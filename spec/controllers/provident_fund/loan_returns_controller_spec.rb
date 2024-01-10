# == Schema Information
#
# Table name: provident_fund_loan_returns
#
#  id            :integer          not null, primary key
#  date          :date
#  amount        :float(24)
#  department_id :integer
#  loan_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe ProvidentFund::LoanReturnsController, type: :controller do

  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id:@company.id)
    @employee = FactoryGirl.create(:employee, role:Employee::ROLE[:admin], department_id:@department.id)
    @rule = FactoryGirl.create(:provident_fund_rule)
    @account = FactoryGirl.create(:provident_fund_account, employee_id: @employee.id, rule_id: @rule.id, department_id: @department.id)
    @account_1 = FactoryGirl.create(:provident_fund_account, employee_id: @employee.id, rule_id: @rule.id, department_id: @department.id)
    @provident_fund_loan = FactoryGirl.create(:provident_fund_loan,pf_account_id:@account.id, department_id:@department.id)
    @provident_fund_loan_1 = FactoryGirl.create(:provident_fund_loan,is_closed: false,pf_account_id:@account_1.id, department_id:@department.id)
    @provident_fund_loan_return = FactoryGirl.create(:provident_fund_loan_return, department_id:@department.id,loan_id:@provident_fund_loan.id)
    session[:department_id] = @department.id
    sign_in(@employee)
  end

  describe 'get # return_form' do
    it 'should assign a newly provident_fund_loan_return' do
      xhr :get, :return_form, format: :js
      expect(assigns(:provident_fund_loan_return)).to be_a_new(ProvidentFund::LoanReturn)
    end
    context 'When pf_account_id as params founded' do
      it 'should request to return_form' do
        xhr :get, :return_form, format: :js, pf_account_id:@account.id
        expect(response).to be_success
      end
      it 'should assign the loan' do
        loans = @account.provident_fund_loans.where(is_closed: false)
        xhr :get, :return_form, format: :js,pf_account_id:@account.id
        expect(assigns(:loans)).to eq(loans)
      end
    end
    context 'when pf_account_id as params not found' do
      it 'should request to return_form' do
        xhr :get, :return_form, format: :js
        expect(response).to be_success
      end
    end

  end

  describe 'post#create' do
    context 'if loan.provident_fund_loan_returns && ProvidentFund::LoanReturn.create(loan_return_params)' do
      it 'should request to create action' do
        post :create, provident_fund_loan_return: {amount: 500, date: Date.today,loan_id: @provident_fund_loan.id}
        expect(response).to redirect_to(provident_fund_loans_path)
      end
    end
    # context 'if not loan.provident_fund_loan_returns && ProvidentFund::LoanReturn.create(loan_return_params)' do
    #   it 'should request to create action' do
    #     post :create, provident_fund_loan_return: {amount: 500, date: Date.today}
    #     expect(response).to render_template(:new)
    #   end
    # end
  end

  # This should return the minimal set of attributes required to create a valid
  # ProvidentFund::LoanReturn. As you add validations to ProvidentFund::LoanReturn, be sure to
  # adjust the attributes here as well.
  # let(:valid_attributes) {
  #   skip("Add a hash of attributes valid for your model")
  # }
  #
  # let(:invalid_attributes) {
  #   skip("Add a hash of attributes invalid for your model")
  # }
  #
  # # This should return the minimal set of values that should be in the session
  # # in order to pass any filters (e.g. authentication) defined in
  # # ProvidentFund::LoanReturnsController. Be sure to keep this updated too.
  # let(:valid_session) { {} }
  #
  # describe "GET #index" do
  #   it "assigns all provident_fund_loan_returns as @provident_fund_loan_returns" do
  #     loan_return = ProvidentFund::LoanReturn.create! valid_attributes
  #     get :index, params: {}, session: valid_session
  #     expect(assigns(:provident_fund_loan_returns)).to eq([loan_return])
  #   end
  # end
  #
  # describe "GET #show" do
  #   it "assigns the requested provident_fund_loan_return as @provident_fund_loan_return" do
  #     loan_return = ProvidentFund::LoanReturn.create! valid_attributes
  #     get :show, params: {id: loan_return.to_param}, session: valid_session
  #     expect(assigns(:provident_fund_loan_return)).to eq(loan_return)
  #   end
  # end
  #
  # describe "GET #new" do
  #   it "assigns a new provident_fund_loan_return as @provident_fund_loan_return" do
  #     get :new, params: {}, session: valid_session
  #     expect(assigns(:provident_fund_loan_return)).to be_a_new(ProvidentFund::LoanReturn)
  #   end
  # end
  #
  # describe "GET #edit" do
  #   it "assigns the requested provident_fund_loan_return as @provident_fund_loan_return" do
  #     loan_return = ProvidentFund::LoanReturn.create! valid_attributes
  #     get :edit, params: {id: loan_return.to_param}, session: valid_session
  #     expect(assigns(:provident_fund_loan_return)).to eq(loan_return)
  #   end
  # end
  #
  # describe "POST #create" do
  #   context "with valid params" do
  #     it "creates a new ProvidentFund::LoanReturn" do
  #       expect {
  #         post :create, params: {provident_fund_loan_return: valid_attributes}, session: valid_session
  #       }.to change(ProvidentFund::LoanReturn, :count).by(1)
  #     end
  #
  #     it "assigns a newly created provident_fund_loan_return as @provident_fund_loan_return" do
  #       post :create, params: {provident_fund_loan_return: valid_attributes}, session: valid_session
  #       expect(assigns(:provident_fund_loan_return)).to be_a(ProvidentFund::LoanReturn)
  #       expect(assigns(:provident_fund_loan_return)).to be_persisted
  #     end
  #
  #     it "redirects to the created provident_fund_loan_return" do
  #       post :create, params: {provident_fund_loan_return: valid_attributes}, session: valid_session
  #       expect(response).to redirect_to(ProvidentFund::LoanReturn.last)
  #     end
  #   end
  #
  #   context "with invalid params" do
  #     it "assigns a newly created but unsaved provident_fund_loan_return as @provident_fund_loan_return" do
  #       post :create, params: {provident_fund_loan_return: invalid_attributes}, session: valid_session
  #       expect(assigns(:provident_fund_loan_return)).to be_a_new(ProvidentFund::LoanReturn)
  #     end
  #
  #     it "re-renders the 'new' template" do
  #       post :create, params: {provident_fund_loan_return: invalid_attributes}, session: valid_session
  #       expect(response).to render_template("new")
  #     end
  #   end
  # end
  #
  # describe "PUT #update" do
  #   context "with valid params" do
  #     let(:new_attributes) {
  #       skip("Add a hash of attributes valid for your model")
  #     }
  #
  #     it "updates the requested provident_fund_loan_return" do
  #       loan_return = ProvidentFund::LoanReturn.create! valid_attributes
  #       put :update, params: {id: loan_return.to_param, provident_fund_loan_return: new_attributes}, session: valid_session
  #       loan_return.reload
  #       skip("Add assertions for updated state")
  #     end
  #
  #     it "assigns the requested provident_fund_loan_return as @provident_fund_loan_return" do
  #       loan_return = ProvidentFund::LoanReturn.create! valid_attributes
  #       put :update, params: {id: loan_return.to_param, provident_fund_loan_return: valid_attributes}, session: valid_session
  #       expect(assigns(:provident_fund_loan_return)).to eq(loan_return)
  #     end
  #
  #     it "redirects to the provident_fund_loan_return" do
  #       loan_return = ProvidentFund::LoanReturn.create! valid_attributes
  #       put :update, params: {id: loan_return.to_param, provident_fund_loan_return: valid_attributes}, session: valid_session
  #       expect(response).to redirect_to(loan_return)
  #     end
  #   end
  #
  #   context "with invalid params" do
  #     it "assigns the provident_fund_loan_return as @provident_fund_loan_return" do
  #       loan_return = ProvidentFund::LoanReturn.create! valid_attributes
  #       put :update, params: {id: loan_return.to_param, provident_fund_loan_return: invalid_attributes}, session: valid_session
  #       expect(assigns(:provident_fund_loan_return)).to eq(loan_return)
  #     end
  #
  #     it "re-renders the 'edit' template" do
  #       loan_return = ProvidentFund::LoanReturn.create! valid_attributes
  #       put :update, params: {id: loan_return.to_param, provident_fund_loan_return: invalid_attributes}, session: valid_session
  #       expect(response).to render_template("edit")
  #     end
  #   end
  # end
  #
  # describe "DELETE #destroy" do
  #   it "destroys the requested provident_fund_loan_return" do
  #     loan_return = ProvidentFund::LoanReturn.create! valid_attributes
  #     expect {
  #       delete :destroy, params: {id: loan_return.to_param}, session: valid_session
  #     }.to change(ProvidentFund::LoanReturn, :count).by(-1)
  #   end
  #
  #   it "redirects to the provident_fund_loan_returns list" do
  #     loan_return = ProvidentFund::LoanReturn.create! valid_attributes
  #     delete :destroy, params: {id: loan_return.to_param}, session: valid_session
  #     expect(response).to redirect_to(provident_fund_loan_returns_url)
  #   end
  # end

end
