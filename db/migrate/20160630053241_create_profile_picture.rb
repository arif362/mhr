class CreateProfilePicture < ActiveRecord::Migration
  def change
    create_table :profile_pictures do |t|
      t.integer :employee_id
      t.string :image
      t.boolean :is_active
    end
  end
end
