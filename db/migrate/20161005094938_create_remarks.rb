class CreateRemarks < ActiveRecord::Migration
  def change
    create_table :remarks do |t|
      t.text :message
      t.integer :remarkable_id
      t.string :remarkable_type
      t.boolean :is_seen, default: false
      t.boolean :is_admin, default: true
      t.timestamps null: false
    end
  end
end
