# == Schema Information
#
# Table name: payroll_employee_categories
#
#  id          :integer          not null, primary key
#  employee_id :integer
#  category_id :integer
#  amount      :float(24)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  percentage  :float(24)
#

FactoryGirl.define do
  factory :payroll_employee_category, class: 'Payroll::EmployeeCategory' do
    percentage 10.0
    amount 10.0
  end
end
