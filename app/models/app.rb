class App < ApplicationRecord
  belongs_to :user
  has_many :build, dependent: :destroy
  has_many :deployment, dependent: :destroy
  has_many :device

  validates :user, presence: true
  APP_NAME_REGEX = /\A[a-zA-Z][a-zA-Z0-9\-\_]*\z/
  validates :name, uniqueness: { scope: :user }, presence: true,
            format: { with: APP_NAME_REGEX }
end
