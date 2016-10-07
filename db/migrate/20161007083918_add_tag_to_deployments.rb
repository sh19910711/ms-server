class AddTagToDeployments < ActiveRecord::Migration[5.0]
  def change
    add_column :deployments, :tag, :string
  end
end
