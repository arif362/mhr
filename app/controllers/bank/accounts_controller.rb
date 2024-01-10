class Bank::AccountsController < ApplicationController
  before_filter :current_ability
  before_action :set_bank_account, only: [:edit, :update, :destroy]

  def index
    @bank_accounts = current_department.bank_accounts
  end

  def new
    @bank_account = Bank::Account.new
  end

  def create
    bank_account = current_department.bank_accounts.build(bank_account_params)
    respond_to do |format|
      format.html do
        if bank_account.save
          redirect_to bank_accounts_path, success: 'Bank Account has been created successfully'
        else
          redirect_to new_bank_account_path, error: 'Unable to bank account, Please try again!'
        end
      end
    end
  end

  def edit
  end

  def update
    if @bank_account.present?
      if @bank_account.update_attributes(bank_account_params)
        redirect_to bank_accounts_path, success: 'Account has been updated successfully'
      else
        render :edit
      end
    else
      redirect_to bank_accounts_path, error: 'Bank account not found'
    end
  end

  def destroy
    if @bank_account.present?
      if @bank_account.destroy
        redirect_to bank_accounts_path, success: 'Account has been deleted successfully'
      else
        redirect_to bank_accounts_path, error: 'Unable to delete account, Please try again!'
      end
    else
      redirect_to bank_accounts_path, error: 'Bank account not found'
    end
  end

  private

  def bank_account_params
    params.require(:bank_account).permit!
  end

  def set_bank_account
    @bank_account = current_department.bank_accounts.find_by_id(params[:id])
  end
end
