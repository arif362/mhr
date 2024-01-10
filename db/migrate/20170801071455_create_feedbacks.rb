class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :name
      t.string :email
      t.integer :design
      t.integer :response
      t.integer :functional
      t.integer :overall
      t.float :rate
      t.text :comments

      t.timestamps null: false
    end
  end
end
