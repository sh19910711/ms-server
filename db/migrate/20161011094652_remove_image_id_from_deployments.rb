class RemoveImageIdFromDeployments < ActiveRecord::Migration[5.0]
  def change
    remove_column :deployments, :image_id
  end
end
