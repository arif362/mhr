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

module Payroll
  class EmployeeCategory < Base
    belongs_to :employee
    belongs_to :category, class_name: 'Payroll::Category'
    accepts_nested_attributes_for :employee
  end
end

