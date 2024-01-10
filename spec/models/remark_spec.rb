# == Schema Information
#
# Table name: remarks
#
#  id              :integer          not null, primary key
#  message         :text(65535)
#  remarkable_id   :integer
#  remarkable_type :string(255)
#  is_seen         :boolean          default(FALSE)
#  is_admin        :boolean          default(TRUE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  remarked_by_id  :integer
#

require 'rails_helper'

RSpec.describe Remark, type: :model do
end
