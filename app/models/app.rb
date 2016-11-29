class App < ApplicationRecord
  include Redis::Objects

  belongs_to :user
  has_many :builds, dependent: :destroy
  has_many :deployments, dependent: :destroy
  has_many :devices, dependent: :nullify

  sorted_set :log

  validates :user, presence: true
  APP_NAME_REGEX = /\A[a-zA-Z][a-zA-Z0-9\-\_]*\z/
  validates :name, uniqueness: { scope: :user }, presence: true,
            format: { with: APP_NAME_REGEX }

  def add_device!(device)
    device.app = self
    device.save!
  end

  def log_messages(since)
    self.log.rangebyscore(since, Float::INFINITY) || []
  end
end
