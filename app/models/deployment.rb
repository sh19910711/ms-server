class Deployment < ApplicationRecord
  belongs_to :app

  validates :app, presence: true
  validates :image, presence: true
  validates :board, inclusion: { in: SUPPORTED_BOARDS }
end
