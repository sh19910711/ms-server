class Image < ApplicationRecord
  belongs_to :deployment
  mount_uploader :file, ImageUploader

  validates :board, inclusion: { in: SUPPORTED_BOARDS }
end
