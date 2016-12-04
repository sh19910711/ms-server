class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable, :authentication_keys => [:name]

  include DeviseTokenAuth::Concerns::User

  USER_NAME_REGEX = /\A[a-zA-Z][a-zA-Z0-9\-\_\.]*\z/
  validates :name, presence: true, uniqueness: true,
            exclusion: { in: RESERVED_USER_NAMES, message: "%{value} is not available." }, format: { with: USER_NAME_REGEX }

  validates :email, presence: true
  has_many :apps, dependent: :destroy
  has_many :devices, dependent: :destroy
  # disable email confirmation in test and development
  before_save { skip_confirmation! } unless Rails.env.production?
end
