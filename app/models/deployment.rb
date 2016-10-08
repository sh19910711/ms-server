class Deployment < ApplicationRecord
  belongs_to :app
  mount_uploader :image, ImageUploader

  validates :board, presence: true
  validates :board, inclusion: { in: SUPPORTED_BOARDS }
end
