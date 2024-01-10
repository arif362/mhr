# == Schema Information
#
# Table name: community_posts
#
#  id                    :integer          not null, primary key
#  title                 :string(255)
#  community_category_id :integer
#  content               :text(65535)
#  attachment            :string(255)
#  author_id             :integer
#  is_published          :boolean          default(TRUE)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  slug                  :string(255)
#

module Community
  class Post < Base

    extend FriendlyId
    friendly_id :post_slug, use: [:slugged, :finders]

    mount_uploader :attachment, ImageUploader
    has_many :community_comments, :class_name => 'Community::Comment', dependent: :destroy
    belongs_to :author, class_name: 'Employee', foreign_key: :author_id
    belongs_to :community_category, :class_name => 'Community::Category', foreign_key: :community_category_id
    validates_presence_of :title


    def post_slug
      posts = Community::Post.all.where(title: title)
      if posts.present?
        title + '_' +posts.count.to_s
      else
        title
      end
    end
  end
end

