# == Schema Information
#
# Table name: community_categories
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text(65535)
#  is_active   :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  slug        :string(255)
#

require 'rails_helper'

RSpec.describe Community::Category, type: :model do
end
