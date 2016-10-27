class CreateJoinTableAppDevice < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :devices, :apps
    remove_column :devices, :app_id
    create_join_table :apps, :devices do |t|
      # t.index [:app_id, :device_id]
      # t.index [:device_id, :app_id]
    end
  end
end
