class AddSlugToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :slug, :string, uniq: true
  end
end
