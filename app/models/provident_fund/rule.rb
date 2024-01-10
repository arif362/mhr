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

class ProvidentFund::Rule < ActiveRecord::Base
  has_many :accounts, :class_name => 'ProvidentFund::Account', dependent: :destroy
  has_many :return_policies, :class_name => 'ProvidentFund::ReturnPolicy', dependent: :destroy

  validates_presence_of :company_contribution, :employee_contribution
  accepts_nested_attributes_for :return_policies, :reject_if => lambda { |a| a[:year].blank? || a[:company_percentage].blank? }, :allow_destroy => true
end
