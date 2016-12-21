class RemoveBuildIdFromDeployments < ActiveRecord::Migration[5.0]
  def change
    remove_column :deployments, :build_id
  end
end
