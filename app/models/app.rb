class App < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :devices

  validates :user, presence: true
  APP_NAME_REGEX = /\A[a-zA-Z][a-zA-Z0-9\-\_]*\z/
  validates :name, uniqueness: { scope: :user }, presence: true,
            format: { with: APP_NAME_REGEX }
end
