class App < ApplicationRecord
  has_and_belongs_to_many :devices

  APP_NAME_REGEX = /[a-zA-Z][a-zA-Z0-9\-\_]*/
  validates :name, uniqueness: true, presence: true,
            format: { with: APP_NAME_REGEX }
end
