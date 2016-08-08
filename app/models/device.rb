class Device < ApplicationRecord
  has_and_belongs_to_many :apps
  validates :status, inclusion: { in: DEVICE_STATUSES }
  validates :board, inclusion: { in: SUPPORTED_BOARDS }
end
