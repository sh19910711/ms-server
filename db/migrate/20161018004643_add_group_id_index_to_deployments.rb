class AddGroupIdIndexToDeployments < ActiveRecord::Migration[5.0]
  def change
    add_index :deployments, :group_id
  end
end
