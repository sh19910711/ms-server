class CreateDeployments < ActiveRecord::Migration[5.0]
  def change
    create_table :deployments do |t|
      t.string :name
      t.references :app, foreign_key: true
      t.string :image

      t.timestamps
    end
  end
end
