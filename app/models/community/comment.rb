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

module Community
  class Comment < Base

    # extend FriendlyId
    # friendly_id :content, use: [:slugged, :finders]

    mount_uploader :attachment, ImageUploader
    belongs_to :community_post, class_name: 'Community::Post', foreign_key: :post_id
    belongs_to :author, class_name: 'Employee', foreign_key: :author_id
    validates_presence_of :content
  end
end
