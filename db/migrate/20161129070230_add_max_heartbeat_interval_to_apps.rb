class AddMaxHeartbeatIntervalToApps < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :max_heartbeat_interval, :integer, default: 3 * 60
  end
end
