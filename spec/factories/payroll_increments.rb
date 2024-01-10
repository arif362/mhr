# == Schema Information
#
# Table name: payroll_increments
#
#  id               :integer          not null, primary key
#  employee_id      :integer
#  department_id    :integer
#  present_basic    :float(24)
#  previous_basic   :float(24)
#  is_active        :boolean
#  active_date      :date
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  incremented_by   :string(255)
#  increment_amount :float(24)
#

FactoryGirl.define do
  factory :payroll_increment, class: 'Payroll::Increment' do
    employee_id 1
    department_id 1
    present_basic "9.99"
    previous_basic "9.99"
    increment_amount "9.99"
    is_active false
    active_date "2016-10-05"
  end
end
