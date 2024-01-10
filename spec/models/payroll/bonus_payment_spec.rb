# == Schema Information
#
# Table name: payroll_bonus_payments
#
#  id             :integer          not null, primary key
#  reason         :string(255)
#  message        :text(65535)
#  amount         :float(24)
#  employee_id    :integer
#  department_id  :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  payment_method :string(255)
#  date           :date
#

require 'rails_helper'

RSpec.describe Payroll::BonusPayment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
