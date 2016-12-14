class AddReleasedAtToDeployments < ActiveRecord::Migration[5.0]
  def change
    add_column :deployments, :released_at, :datetime
  end
end
