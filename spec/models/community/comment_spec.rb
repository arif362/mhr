# == Schema Information
#
# Table name: community_comments
#
#  id           :integer          not null, primary key
#  content      :text(65535)
#  post_id      :integer
#  author_id    :integer
#  attachment   :string(255)
#  is_published :boolean          default(TRUE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe Community::Comment, type: :model do
end
