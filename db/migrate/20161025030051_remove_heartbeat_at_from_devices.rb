class RemoveHeartbeatAtFromDevices < ActiveRecord::Migration[5.0]
  def change
    remove_column :devices, :heartbeat_at
  end
end
