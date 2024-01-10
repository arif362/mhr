# == Schema Information
#
# Table name: provident_fund_contributions
#
#  id                        :integer          not null, primary key
#  provident_fund_account_id :integer
#  basis_salary              :float(24)
#  employee_contribution     :float(24)
#  company_contribution      :float(24)
#  month                     :integer
#  year                      :integer
#  is_confirmed              :boolean          default(FALSE)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

require 'rails_helper'

RSpec.describe ProvidentFund::Contribution, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
