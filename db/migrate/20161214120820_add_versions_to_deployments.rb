class AddVersionsToDeployments < ActiveRecord::Migration[5.0]
  def change
    add_column :deployments, :major_version, :integer
    add_index :deployments, :major_version
    add_column :deployments, :minor_version, :integer
  end
end
