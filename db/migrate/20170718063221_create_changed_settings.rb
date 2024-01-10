class CreateChangedSettings < ActiveRecord::Migration
  def change
    create_table :changed_settings do |t|
      t.time :open_time
      t.time :close_time
      t.float :working_hours
      t.date :from_date
      t.date :to_date
      t.references :department, foreign_key: true

      t.timestamps null: false
    end
  end
end
