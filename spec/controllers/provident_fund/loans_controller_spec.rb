# == Schema Information
#
# Table name: provident_fund_loans
#
#  id            :integer          not null, primary key
#  pf_account_id :integer
#  department_id :integer
#  amount        :float(24)
#  description   :text(65535)
#  return_policy :string(255)
#  installment   :integer
#  return_date   :date
#  date          :date
#  is_closed     :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe ProvidentFund::LoansController, type: :controller do
  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id:@company.id)
    @employee = FactoryGirl.create(:employee, role:Employee::ROLE[:admin], department_id:@department.id)
    @rule = FactoryGirl.create(:provident_fund_rule)
    @account = FactoryGirl.create(:provident_fund_account, employee_id: @employee.id, rule_id: @rule.id, department_id: @department.id)
    @provident_fund_loan = FactoryGirl.create(:provident_fund_loan,pf_account_id:@account.id, department_id:@department.id)
    session[:department_id] = @department.id
    sign_in(@employee)
  end

  describe 'get # index' do
    it 'should request to index' do
      get :index
      expect(response).to be_success
    end
    it 'should assign provident_fund_loans' do
      get :index
      expect(assigns(:provident_fund_loans)).to eq([@provident_fund_loan])
    end
  end

  describe 'get # new' do
    it 'should request to new action' do
      get :new
      expect(response).to be_success
    end
    it 'should request to new action' do
      get :new
      expect(assigns(:provident_fund_loan)).to be_a_new(ProvidentFund::Loan)
    end
  end

  describe 'post#create' do
    context 'When provident_fund_loan saved' do
      it 'should request to create action' do
        post :create, provident_fund_loan: {pf_account_id:@account.id+1,amount: 500, description:'loan', return_policy:'On Request',date: Date.today,return_date: Date.today.at_end_of_day}
        expect(response).to redirect_to(provident_fund_loans_path)
      end
      it 'should increment by 1'do
        count = ProvidentFund::Loan.count
        post :create, provident_fund_loan: {pf_account_id:@account.id+1,amount: 500, description:'loan', return_policy:'On Request',date: Date.today,return_date: Date.today.at_end_of_day}
        expect(ProvidentFund::Loan.count).to eq(count+1)
      end
    end
    context 'When provident_fund_loan not saved' do
      it 'should request to create action' do
        post :create, provident_fund_loan: { return_policy:'On Request',date: Date.today}
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'get # show' do
    it 'should request to show action' do
      get :show, id: @provident_fund_loan.id
      expect(response).to be_success
    end
    it 'should assign @provident_fund_loan' do
      get :show, id: @provident_fund_loan.id
      expect(assigns(:provident_fund_loan)).to eq(@provident_fund_loan)
    end
  end

  describe 'get#edit' do
    it 'should request to edit action' do
      get :edit, id:@provident_fund_loan.id
      expect(response).to be_success
    end
    it 'should assign @provident_fund_loan' do
      get :edit, id:@provident_fund_loan.id
      expect(assigns(:provident_fund_loan)).to eq(@provident_fund_loan)
    end
  end

  describe 'put#update' do
    context 'when @provident_fund_loan not present' do
      it 'should request to update action' do
        put :update, id:@provident_fund_loan.id+1
        expect(response).to redirect_to(provident_fund_loans_path)
      end
    end
    context 'when @provident_fund_loan present' do
      context 'when attributes updated' do
        it 'should request to update action' do
          put :update, id:@provident_fund_loan.id, provident_fund_loan: {return_policy:'On Request',date: Date.today}
          expect(response).to redirect_to(provident_fund_loans_path)
        end
      end
      context 'when attributes updated' do
        it 'should request to update action' do
          put :update, id:@provident_fund_loan.id, provident_fund_loan: {return_policy:'',date:''}
          expect(response).to render_template(:edit)
        end
      end
    end
  end

  describe 'get#history' do
    context ' when pf_account_id present' do
      it 'should request to history action' do
        xhr :get, :history, format: :js,pf_account_id:@account.id
        expect(response).to be_success
      end
    end
    context 'when pf_account_id not present' do
      it 'should request to history action' do
        xhr :get, :history, format: :js, pf_account_id:@account.id
        expect(response).to be_success
      end
    end
  end

  describe 'delete # destroy' do
    context 'when provident_fund_loan present' do
      it 'should request to destroy' do
        delete :destroy, id:@provident_fund_loan.id
        expect(response).to redirect_to(provident_fund_loans_path)
      end
    end
    context 'when provident_fund_loan not present' do
      it 'should request to destroy' do
        delete :destroy, id:@provident_fund_loan.id+1
        expect(response).to redirect_to(provident_fund_loans_path)
      end
    end
  end

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
  # # ProvidentFund::LoansController. Be sure to keep this updated too.
  # let(:valid_session) { {} }
  #
  # describe "GET #index" do
  #   it "assigns all provident_fund_loans as @provident_fund_loans" do
  #     loan = ProvidentFund::Loan.create! valid_attributes
  #     get :index, params: {}, session: valid_session
  #     expect(assigns(:provident_fund_loans)).to eq([loan])
  #   end
  # end
  #
  # describe "GET #show" do
  #   it "assigns the requested provident_fund_loan as @provident_fund_loan" do
  #     loan = ProvidentFund::Loan.create! valid_attributes
  #     get :show, params: {id: loan.to_param}, session: valid_session
  #     expect(assigns(:provident_fund_loan)).to eq(loan)
  #   end
  # end
  #
  # describe "GET #new" do
  #   it "assigns a new provident_fund_loan as @provident_fund_loan" do
  #     get :new, params: {}, session: valid_session
  #     expect(assigns(:provident_fund_loan)).to be_a_new(ProvidentFund::Loan)
  #   end
  # end
  #
  # describe "GET #edit" do
  #   it "assigns the requested provident_fund_loan as @provident_fund_loan" do
  #     loan = ProvidentFund::Loan.create! valid_attributes
  #     get :edit, params: {id: loan.to_param}, session: valid_session
  #     expect(assigns(:provident_fund_loan)).to eq(loan)
  #   end
  # end
  #
  # describe "POST #create" do
  #   context "with valid params" do
  #     it "creates a new ProvidentFund::Loan" do
  #       expect {
  #         post :create, params: {provident_fund_loan: valid_attributes}, session: valid_session
  #       }.to change(ProvidentFund::Loan, :count).by(1)
  #     end
  #
  #     it "assigns a newly created provident_fund_loan as @provident_fund_loan" do
  #       post :create, params: {provident_fund_loan: valid_attributes}, session: valid_session
  #       expect(assigns(:provident_fund_loan)).to be_a(ProvidentFund::Loan)
  #       expect(assigns(:provident_fund_loan)).to be_persisted
  #     end
  #
  #     it "redirects to the created provident_fund_loan" do
  #       post :create, params: {provident_fund_loan: valid_attributes}, session: valid_session
  #       expect(response).to redirect_to(ProvidentFund::Loan.last)
  #     end
  #   end
  #
  #   context "with invalid params" do
  #     it "assigns a newly created but unsaved provident_fund_loan as @provident_fund_loan" do
  #       post :create, params: {provident_fund_loan: invalid_attributes}, session: valid_session
  #       expect(assigns(:provident_fund_loan)).to be_a_new(ProvidentFund::Loan)
  #     end
  #
  #     it "re-renders the 'new' template" do
  #       post :create, params: {provident_fund_loan: invalid_attributes}, session: valid_session
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
  #     it "updates the requested provident_fund_loan" do
  #       loan = ProvidentFund::Loan.create! valid_attributes
  #       put :update, params: {id: loan.to_param, provident_fund_loan: new_attributes}, session: valid_session
  #       loan.reload
  #       skip("Add assertions for updated state")
  #     end
  #
  #     it "assigns the requested provident_fund_loan as @provident_fund_loan" do
  #       loan = ProvidentFund::Loan.create! valid_attributes
  #       put :update, params: {id: loan.to_param, provident_fund_loan: valid_attributes}, session: valid_session
  #       expect(assigns(:provident_fund_loan)).to eq(loan)
  #     end
  #
  #     it "redirects to the provident_fund_loan" do
  #       loan = ProvidentFund::Loan.create! valid_attributes
  #       put :update, params: {id: loan.to_param, provident_fund_loan: valid_attributes}, session: valid_session
  #       expect(response).to redirect_to(loan)
  #     end
  #   end
  #
  #   context "with invalid params" do
  #     it "assigns the provident_fund_loan as @provident_fund_loan" do
  #       loan = ProvidentFund::Loan.create! valid_attributes
  #       put :update, params: {id: loan.to_param, provident_fund_loan: invalid_attributes}, session: valid_session
  #       expect(assigns(:provident_fund_loan)).to eq(loan)
  #     end
  #
  #     it "re-renders the 'edit' template" do
  #       loan = ProvidentFund::Loan.create! valid_attributes
  #       put :update, params: {id: loan.to_param, provident_fund_loan: invalid_attributes}, session: valid_session
  #       expect(response).to render_template("edit")
  #     end
  #   end
  # end
  #
  # describe "DELETE #destroy" do
  #   it "destroys the requested provident_fund_loan" do
  #     loan = ProvidentFund::Loan.create! valid_attributes
  #     expect {
  #       delete :destroy, params: {id: loan.to_param}, session: valid_session
  #     }.to change(ProvidentFund::Loan, :count).by(-1)
  #   end
  #
  #   it "redirects to the provident_fund_loans list" do
  #     loan = ProvidentFund::Loan.create! valid_attributes
  #     delete :destroy, params: {id: loan.to_param}, session: valid_session
  #     expect(response).to redirect_to(provident_fund_loans_url)
  #   end
  # end

end
