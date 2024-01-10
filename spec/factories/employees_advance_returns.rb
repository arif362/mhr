# == Schema Information
#
# Table name: employees_advance_returns
#
#  id            :integer          not null, primary key
#  date          :date
#  amount        :float(24)
#  employee_id   :integer
#  department_id :integer
#  advance_id    :integer
#  salary_id     :integer
#  return_from   :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do
  factory :employees_advance_return, class: 'Employees::AdvanceReturn' do
    date Date.today
    amount 500
  end
end
