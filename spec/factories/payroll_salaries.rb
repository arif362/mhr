# == Schema Information
#
# Table name: payroll_salaries
#
#  id                 :integer          not null, primary key
#  employee_id        :integer
#  department_id      :integer
#  payment_method     :string(255)
#  addition_category  :text(65535)
#  bonus              :float(24)
#  total              :float(24)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  deduction_category :text(65535)
#  month              :integer
#  year               :integer
#  basic_salary       :float(24)
#  total_addition     :float(24)
#  total_deduction    :float(24)
#  is_confirmed       :boolean          default(TRUE)
#  from_combined      :boolean          default(FALSE)
#

FactoryGirl.define do
  factory :payroll_salary, class: 'Payroll::Salary' do
    payment_method Faker::Lorem.word
    addition_category {{
        home_allowance_amount: 10000.0,
        over_time: 1,
        over_time_amount: 100.0
    }}
    total 26671
    deduction_category {{
        unpaid_leave_days: 1,
        unpaid_leave_deduct: 1129.0,
        late_days: 3,
        late_time: 200.0,
        late_time_deduct: 500.0,
        less_worked_hours: 9.0,
        less_work_deduct: 1000.0,
        absent_days: 2,
        absent_deduct: 800.0
    }}
    month Date.today.month
    year Date.today.year
    basic_salary 20000
    total_addition 30100 #total earnings basic salary + addition
    total_deduction 3429
    is_confirmed false
  end
end
