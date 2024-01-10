module Employees::AdvancesHelper
  def calculate_balance(balance, given_amount, return_amount)
    given_amount = 0.0 if given_amount == '-'
    return_amount = 0.0 if return_amount == '-'
    balance - given_amount + return_amount
  end
end
