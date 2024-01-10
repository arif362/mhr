# == Schema Information
#
# Table name: provident_fund_return_policies
#
#  id                 :integer          not null, primary key
#  year               :float(24)
#  company_percentage :float(24)
#  rule_id            :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'rails_helper'

RSpec.describe ProvidentFund::ReturnPolicy, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
