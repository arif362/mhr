# == Schema Information
#
# Table name: designations
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  description   :text(65535)
#  is_active     :boolean          default(FALSE)
#  department_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Designation, type: :model do
end
