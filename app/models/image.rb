class Image < ApplicationRecord
  belongs_to :deployment
  mount_uploader :file, ImageUploader
end
