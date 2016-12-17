class AddVersionToDeployment < ActiveRecord::Migration[5.0]
  def change
    add_column :deployments, :version, :integer
    remove_column :deployments, :major_version
    remove_column :deployments, :minor_version
  end
end
