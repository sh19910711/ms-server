class Device < ApplicationRecord
  belongs_to :app, optional: true

  validates :status, inclusion: { in: DEVICE_STATUSES }
end
