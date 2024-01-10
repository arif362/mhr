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

module Community
  class Category < Base

    extend FriendlyId
    friendly_id :title, use: [:slugged, :finders]

    has_many :community_posts, :class_name => 'Community::Post', foreign_key: :community_category_id, dependent: :destroy
  end
end
