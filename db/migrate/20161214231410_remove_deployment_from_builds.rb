class RemoveDeploymentFromBuilds < ActiveRecord::Migration[5.0]
  def change
    remove_column :builds, :deployment_id
  end
end
