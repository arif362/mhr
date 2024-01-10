class CreateComments < ActiveRecord::Migration
  def change
    create_table :community_comments do |t|
      t.text :content
      t.integer :post_id
      t.integer :author_id
      t.string :attachment
      t.boolean :is_published, default: true

      t.timestamps null: false
    end
  end
end
