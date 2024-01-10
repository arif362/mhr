# == Schema Information
#
# Table name: contact_us
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  subject    :text(65535)
#  message    :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe ContactUs, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
