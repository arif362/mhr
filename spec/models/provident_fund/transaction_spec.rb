# == Schema Information
#
# Table name: provident_fund_transactions
#
#  id             :integer          not null, primary key
#  transable_type :string(255)
#  transable_id   :integer
#  debit          :float(24)
#  credit         :float(24)
#  pf_account_id  :float(24)
#  department_id  :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'rails_helper'

RSpec.describe ProvidentFund::Transaction, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
