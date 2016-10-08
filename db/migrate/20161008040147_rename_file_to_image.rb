class RenameFileToImage < ActiveRecord::Migration[5.0]
  def change
    rename_column :deployments, :file, :image
  end
end
