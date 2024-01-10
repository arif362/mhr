class CreateLeaveApplications < ActiveRecord::Migration
  def change
    create_table :leave_applications do |t|
      t.text :message
      t.text :note
      t.string :attachment
      t.boolean :is_approved, default: false
      t.integer :employee_id
      t.integer :leave_category_id

      t.timestamps null: false
    end
  end
end
