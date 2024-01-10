class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.integer :employee_id
      t.date :date
      t.boolean :is_complete

      t.timestamps
    end
  end
end
