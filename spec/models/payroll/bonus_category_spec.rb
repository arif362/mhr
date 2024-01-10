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

require 'rails_helper'

RSpec.describe Payroll::BonusCategory, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
