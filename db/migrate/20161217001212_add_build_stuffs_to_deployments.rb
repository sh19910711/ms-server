class AddBuildStuffsToDeployments < ActiveRecord::Migration[5.0]
  def change
    add_column :deployments, :source_file, :binary
    add_column :deployments, :buildlog, :text
    add_column :deployments, :status, :string
  end
end
