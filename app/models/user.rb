class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true
  has_many :apps
  has_many :devices
  # disable email confirmation in the development mode
  before_save { skip_confirmation! } if Rails.env.development?
end
