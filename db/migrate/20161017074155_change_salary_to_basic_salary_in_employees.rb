class ChangeSalaryToBasicSalaryInEmployees < ActiveRecord::Migration
  def change
    rename_column :employees, :salary, :basic_salary
  end
end
