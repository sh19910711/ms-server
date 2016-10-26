class Device < ApplicationRecord
  belongs_to :user
  belongs_to :app
  has_many :envvars, class_name: 'Envvar'

  DEVICE_NAME_REGEX = /\A[a-zA-Z][a-zA-Z0-9\-\_]*\z/
  validates :user, presence: true
  validates :device_secret, presence: true
  validates :name, uniqueness: { scope: :user }, presence: true,
            format: { with: DEVICE_NAME_REGEX }
  validates :board, inclusion: { in: SUPPORTED_BOARDS }
end
