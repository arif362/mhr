class AddSlugToCommunityCategories < ActiveRecord::Migration
  def change
    add_column :community_categories, :slug, :string, uniq: true
  end
end
