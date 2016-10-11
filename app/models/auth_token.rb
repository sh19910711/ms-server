class AuthToken < ApplicationRecord
  validates :client, presence: true
  validates :uid, presence: true
  validates :token, presence: true
  validates :access_token, presence: true
  validates :expires_at, presence: true
end
