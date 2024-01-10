class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.date :in_date
      t.datetime :in_time
      t.datetime :out_time
      t.decimal :duration
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
