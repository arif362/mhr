# == Schema Information
#
# Table name: bank_accounts
#
#  id            :integer          not null, primary key
#  department_id :integer
#  name          :string(255)
#  number        :string(255)
#  bank_name     :string(255)
#  bank_branch   :string(255)
#  balance       :float(24)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Bank::AccountsController, type: :controller do

  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id:@company.id)
    @employee = FactoryGirl.create(:employee, role:Employee::ROLE[:admin], department_id:@department.id)
    @bank_account = FactoryGirl.create(:bank_account, department_id:@department.id)
    session[:department_id] = @department.id
    sign_in(@employee)
  end

  describe 'get # index' do
    it 'should request to index' do
      get :index
      expect(response).to be_success
    end
  end

  describe 'get # new' do
    it 'should to new action' do
      get :new
      expect(response).to be_success
    end
    it 'should assign a new @bank_account' do
      get :new
      expect(assigns(:bank_account)).to be_a_new(Bank::Account)
    end
  end

  describe 'post # create' do
    context 'if bank_account save' do
      it 'should request to create' do
        post :create, bank_account: { name: Faker::Name.name,department_id:@department.id, number: Faker::Number.number(10)}
        expect(response).to redirect_to(bank_accounts_path)
      end
      it 'should increment by 1 ' do
        count = Bank::Account.count
        post :create, bank_account: { name: Faker::Name.name,department_id:@department.id, number: Faker::Number.number(10)}
        expect(Bank::Account.count).to eq(count+1)
      end
    end
    context 'if bank_account not save' do
      it 'should request to create' do
        post :create, bank_account: { name: nil}
        expect(response).to redirect_to(new_bank_account_path)
      end
    end
  end

  describe 'get # edit' do
    it 'should request to edit' do
      get :edit, id:@bank_account.id
      expect(response).to be_success
    end
  end

  describe 'put # update' do
    context ' if @bank_account.present?' do
      context 'if @bank_account updated' do
        it 'should request to update' do
          put :update, id:@bank_account.id, bank_account: { name: Faker::Name.name,department_id:@department.id}
          expect(response).to redirect_to(bank_accounts_path)
        end
      end
      context 'if @bank_account not updated' do
        it 'should request to update' do
          put :update, id:@bank_account.id, bank_account: { name: nil,department_id:@department.id}
          expect(response).to render_template(:edit)
        end
      end
    end
    context 'if @bank_account not present?' do
      it 'should request to update' do
        put :update, id:@bank_account.id+1, bank_account: { name: Faker::Name.name,department_id:@department.id}
        expect(response).to redirect_to(bank_accounts_path)
      end
    end
  end

  describe 'delete # destroy' do
    context 'if @bank_account.present?' do
      context ' if @bank_account.destroy' do
        it 'should request to destroy' do
          delete :destroy, id: @bank_account.id
          expect(response).to redirect_to(bank_accounts_path)
        end
      end
      # when @bank_account will not be destroyed?
      # context 'if @bank_account not destroy' do
      #   it 'should request to destroy' do
      #     delete :destroy, id: @bank_account.id
      #     expect(response).to redirect_to(bank_accounts_path)
      #   end
      # end
    end
    context 'if @bank_account not present' do
      it 'should request to destroy' do
        delete :destroy, id: @bank_account.id+2
        expect(response).to redirect_to(bank_accounts_path)
      end
    end
  end

end
