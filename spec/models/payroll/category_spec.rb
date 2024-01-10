# == Schema Information
#
# Table name: payroll_categories
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  description   :text(65535)
#  department_id :integer
#  is_add        :boolean          default(TRUE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  is_percentage :boolean          default(TRUE)
#

require 'rails_helper'

RSpec.describe Payroll::Category, type: :model do
end
