class RemoveGroupIdFromDeployments < ActiveRecord::Migration[5.0]
  def change
    remove_column :deployments, :group_id
  end
end
