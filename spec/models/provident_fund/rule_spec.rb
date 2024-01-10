# == Schema Information
#
# Table name: provident_fund_rules
#
#  id                    :integer          not null, primary key
#  company_contribution  :float(24)
#  employee_contribution :string(255)
#  department_id         :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'rails_helper'

RSpec.describe ProvidentFund::Rule, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
