class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.time :open_time
      t.time :close_time
      t.decimal :working_hours
      t.integer :department_id

      t.timestamps null: false
    end
  end
end
