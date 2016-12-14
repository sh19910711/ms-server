class AddDeploymentToBuilds < ActiveRecord::Migration[5.0]
  def change
    add_reference :builds, :deployment, foreign_key: true
  end
end
