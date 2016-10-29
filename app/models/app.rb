class App < ApplicationRecord
  belongs_to :user
  has_many :builds, dependent: :destroy
  has_many :deployments, dependent: :destroy
  has_many :devices

  validates :user, presence: true
  APP_NAME_REGEX = /\A[a-zA-Z][a-zA-Z0-9\-\_]*\z/
  validates :name, uniqueness: { scope: :user }, presence: true,
            format: { with: APP_NAME_REGEX }

  scope :index, -> { select('name') }

  def add_device!(device)
    device.app = self
    device.save!
  end
end
