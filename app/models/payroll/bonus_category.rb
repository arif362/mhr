# == Schema Information
#
# Table name: payroll_bonus_categories
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  is_amount     :boolean          default(TRUE)
#  amount        :float(24)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  department_id :integer
#  message       :text(65535)
#

module Payroll
  class BonusCategory < Base
    belongs_to :department
    validates_presence_of :name
    validates_uniqueness_of :name
  end
end

