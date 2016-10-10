class AddGroupIdToDeployments < ActiveRecord::Migration[5.0]
  def change
    add_column :deployments, :group_id, :string
  end
end
