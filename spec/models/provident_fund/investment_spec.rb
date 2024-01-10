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

RSpec.describe ProvidentFund::Investment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
