# == Schema Information
#
# Table name: provident_fund_accounts
#
#  id             :integer          not null, primary key
#  number         :string(255)
#  rule_id        :integer
#  employee_id    :integer
#  effective_date :date
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  department_id  :integer
#

require 'rails_helper'

RSpec.describe ProvidentFund::Account, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
