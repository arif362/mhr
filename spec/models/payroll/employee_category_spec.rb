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

require 'rails_helper'

RSpec.describe Payroll::EmployeeCategory, type: :model do
end
