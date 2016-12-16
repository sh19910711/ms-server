class AddBuildToDeployments < ActiveRecord::Migration[5.0]
  def change
    add_reference :deployments, :build, foreign_key: true
  end
end
