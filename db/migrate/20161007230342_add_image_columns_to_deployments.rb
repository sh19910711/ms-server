class AddImageColumnsToDeployments < ActiveRecord::Migration[5.0]
  def change
    add_column :deployments, :file, :string
    add_column :deployments, :board, :string
  end
end
