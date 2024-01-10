class CreatePosts < ActiveRecord::Migration
  def change
    create_table :community_posts do |t|
      t.string :title
      t.integer :community_category_id
      t.text :content
      t.string :attachment
      t.integer :author_id
      t.boolean :is_published, default: true

      t.timestamps null: false
    end
  end
end
