class CreateAttendanceDayOffs < ActiveRecord::Migration
  def change
    create_table :attendance_day_offs do |t|
      t.integer :year
      t.date :date
      t.string :day_off_type
      t.decimal :hours
      t.string :title
      t.integer :department_id

      t.timestamps null: false
    end
  end
end
