class MultipleAppsToSingleApp < ActiveRecord::Migration[5.0]
  def change
    add_reference :devices, :app, foreign_key: true
    drop_join_table :devices, :apps
  end
end
