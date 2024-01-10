class AddIdNumberToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :id_card_no, :string
  end
end
