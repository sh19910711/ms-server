class Envvar < ApplicationRecord
  belongs_to :device

  ENVVAR_NAME_REGEX = /\A[A-Z_][A-Z_0-9]*\z/
  validate :name, presence: true, uniqueness: { scope: :device },
           format: { with: ENVVAR_NAME_REGEX }
end
