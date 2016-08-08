class Device < ApplicationRecord
  belongs_to :app, optional: true

  # ready: The device has booted and is ready for running an app.
  # running: The device is running an app.
  validates :status, inclusion: { in: %w(ready running) }
end
