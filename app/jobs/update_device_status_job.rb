class UpdateDeviceStatusJob < ApplicationJob
  queue_as :default

  def perform(*args)
    App.find_each do |app|
      before = Time.now - app.max_heartbeat_interval.seconds
      Device
        .where(app: app)
        .where(status: %w(ready running))
        .where('heartbeated_at < ?', before)
        .find_each |device|
        device.status = 'down'
      end
    end
  end
end
