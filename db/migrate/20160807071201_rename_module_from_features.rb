class RenameModuleFromFeatures < ActiveRecord::Migration
  def change
    rename_column :features, :module, :app_module
  end
end
