# == Schema Information
#
# Table name: feedbacks
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  design     :integer
#  response   :integer
#  functional :integer
#  overall    :integer
#  rate       :float(24)
#  comments   :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Feedback, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
