class RemoveNameFromDeployment < ActiveRecord::Migration[5.0]
  def change
    remove_column :deployments, :name
  end
end
