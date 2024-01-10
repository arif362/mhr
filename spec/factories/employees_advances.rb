# == Schema Information
#
# Table name: employees_advances
#
#  id             :integer          not null, primary key
#  employee_id    :integer
#  amount         :float(24)
#  is_paid        :boolean          default(FALSE)
#  purpose        :text(65535)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  department_id  :integer
#  is_deactivated :boolean          default(FALSE)
#  is_completed   :boolean          default(FALSE)
#  installment    :float(24)
#  return_policy  :string(255)
#  date           :date
#

FactoryGirl.define do
  factory :employees_advance, class: 'Employees::Advance' do
    employee_id 1
    amount "10.0"
    purpose "MyText"
    date Date.today
  end
end
