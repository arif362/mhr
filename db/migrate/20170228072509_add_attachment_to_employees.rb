class AddAttachmentToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :attachment, :string
  end
end
