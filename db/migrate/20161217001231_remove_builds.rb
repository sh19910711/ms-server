class RemoveBuilds < ActiveRecord::Migration[5.0]
  def change
    drop_table :builds
  end
end
