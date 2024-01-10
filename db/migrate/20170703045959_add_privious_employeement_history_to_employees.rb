class AddPriviousEmployeementHistoryToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :previous_employment_history, :string
  end
end
