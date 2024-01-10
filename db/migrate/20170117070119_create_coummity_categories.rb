class CreateCoummityCategories < ActiveRecord::Migration
  def change
    create_table :community_categories do |t|
      t.string :title
      t.text :description
      t.boolean :is_active, default: true

      t.timestamps null: false
    end
  end
end
