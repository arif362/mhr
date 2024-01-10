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

module Payroll
  class Increment < Base
    belongs_to :employee
    belongs_to :department
    validates_presence_of :employee_id
  end
end

