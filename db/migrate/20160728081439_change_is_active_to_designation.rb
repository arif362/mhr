class ChangeIsActiveToDesignation < ActiveRecord::Migration
  def change
    change_column :designations, :is_active,:boolean, :default => false
  end
end
