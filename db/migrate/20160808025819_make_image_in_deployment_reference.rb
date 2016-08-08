class MakeImageInDeploymentReference < ActiveRecord::Migration[5.0]
  def change
    remove_column :deployments, :image
    add_reference :deployments, :image, index: true
  end
end
