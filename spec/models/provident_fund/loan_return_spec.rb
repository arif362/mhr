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

RSpec.describe ProvidentFund::LoanReturn, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
