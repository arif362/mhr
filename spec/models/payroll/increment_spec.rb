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

require 'rails_helper'

RSpec.describe Payroll::Increment, type: :model do
end
