class AddSlugToCommunityPosts < ActiveRecord::Migration
  def change
    add_column :community_posts, :slug, :string, uniq: true
  end
end
