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

class ProvidentFund::ReturnPolicy < ActiveRecord::Base
  belongs_to :rule, :class_name => 'ProvidentFund::Rule'
end
