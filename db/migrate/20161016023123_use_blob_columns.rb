class UseBlobColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :deployments, :image
    remove_column :builds, :source_file
    add_column :deployments, :image, :binary, limit: 32.megabyte
    add_column :builds, :source_file, :binary, limit: 16.megabyte
  end
end
