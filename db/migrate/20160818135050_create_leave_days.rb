class CreateLeaveDays < ActiveRecord::Migration
  def change
    create_table :leave_days do |t|
      t.date :off_date
      t.integer :leave_application_id

      t.timestamps null: false
    end
  end
end
