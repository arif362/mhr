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

FactoryGirl.define do
  factory :payroll_bonus_payment, class: 'Payroll::BonusPayment' do
    amount 5000
  end
end
