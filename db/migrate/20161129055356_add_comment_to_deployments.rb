class AddCommentToDeployments < ActiveRecord::Migration[5.0]
  def change
    add_column :deployments, :comment, :string
  end
end
