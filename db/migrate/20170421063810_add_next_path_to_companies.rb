class AddNextPathToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :next_path, :string
  end
end
