# == Schema Information
#
# Table name: provident_fund_investments
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  pf_type       :string(255)
#  amount        :string(255)
#  maturity_date :date
#  no_year       :float(24)
#  date          :date
#  interest_rate :float(24)
#  no_day        :integer
#  department_id :integer
#  active        :boolean          default(TRUE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe ProvidentFund::InvestmentsController, type: :controller do

  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id: @company.id)
    @employee = FactoryGirl.create(:employee, role: Employee::ROLE[:admin], department_id: @department.id)
    @provident_fund_investment = FactoryGirl.create(:provident_fund_investment, department_id: @department.id)
    session[:department_id] = @department.id
    sign_in(@employee)
  end

  let(:valid_attributes) {
    {
        title: Faker::Lorem.sentence,
        pf_type: Faker::Lorem.sentence,
        amount: 5000,
        interest_rate: 5,
        no_year: 5,
        date: Date.today,
        maturity_date: '2022-12-25'
    }
  }

  let(:invalid_attributes) {
    {
        title: nil,
        pf_type: nil,
        amount: 5000,
        interest_rate: 5,
        no_year: 5,
        date: Date.today,
        maturity_date: '2022-12-25'
    }

  }


  describe "GET #index" do
    it "assigns all provident_fund_investments as @provident_fund_investments" do
      get :index
      expect(response).to be_success
    end
    it "assigns all provident_fund_investments as @provident_fund_investments" do
      get :index
      expect(assigns(:provident_fund_investments)).to eq([@provident_fund_investment])
    end
  end

  describe "GET #new" do
    it "should response to be success" do
      get :new
      expect(response).to be_success
    end
    it "assigns a new provident_fund_investment as @provident_fund_investment" do
      get :new
      expect(assigns(:provident_fund_investment)).to be_a_new(ProvidentFund::Investment)
    end
  end

  describe 'post # create' do
    context ' if @provident_fund_investment save' do
      it 'should request to create action' do
        post :create, provident_fund_investment: valid_attributes
        expect(response).to redirect_to(provident_fund_investments_path)
      end
      it 'should request to create action' do
        post :create, provident_fund_investment: valid_attributes
        expect(assigns(:provident_fund_investment)).to be_a(ProvidentFund::Investment)
      end
      it 'should increment by 1' do
        count = ProvidentFund::Investment.count
        post :create, provident_fund_investment: valid_attributes
        expect(ProvidentFund::Investment.count).to eq(count+1)
        expect(assigns(:provident_fund_investment)).to be_persisted
      end
    end
    context ' if @provident_fund_investment not save' do
      it 'should request to create action' do
        post :create, provident_fund_investment: invalid_attributes
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'get # edit' do
    it 'should request to edit' do
      get :edit, id:@provident_fund_investment.id
      expect(response).to be_success
    end
    it 'should assign @provident_fund_investment' do
      get :edit, id:@provident_fund_investment.id
      expect(assigns(:provident_fund_investment)).to eq(@provident_fund_investment)
    end
  end

  describe 'put # update' do
    context ' when @provident_fund_investment not present' do
      it 'should request to update' do
        put :update, id:@provident_fund_investment.id+11, provident_fund_investment: valid_attributes
        expect(response).to redirect_to(provident_fund_investments_path)
      end
    end
    context 'if updated' do
      it 'should request to update' do
        put :update, id:@provident_fund_investment.id, provident_fund_investment: valid_attributes
        expect(response).to redirect_to(provident_fund_investments_path)
      end
    end
    context 'if not updated' do
      it 'should render to edit' do
        put :update, id:@provident_fund_investment.id, provident_fund_investment: invalid_attributes
        expect(response).to render_template(:edit)
      end
    end

  end

  describe 'delete # destroy' do
    context 'if provident_fund_investment not present' do
      it 'should request to destroy' do
        delete :destroy, id:@provident_fund_investment.id+1
        expect(response).to redirect_to(provident_fund_investments_path)
      end
    end
    it 'should request to destroy' do
      delete :destroy, id:@provident_fund_investment.id
      expect(response).to redirect_to(provident_fund_investments_path)
    end
    it 'should request to destroy' do
      count = ProvidentFund::Investment.count
      delete :destroy, id:@provident_fund_investment.id
      expect(ProvidentFund::Investment.count).to eq(count-1)
    end
  end
end
