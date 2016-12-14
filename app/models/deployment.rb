class Deployment < ApplicationRecord
  belongs_to :app

  validates :app, presence: true
  validates :image, presence: true, if: :released?
  validates :board, inclusion: { in: SUPPORTED_BOARDS }, if: :released?

  before_create :set_versions

  def set_versions
    max = Deployment.where(app: self.app).maximum(:major_version) || 0
    self.major_version ||= max + 1
    self.minor_version ||= 0
  end

  def released?
    self.released_at != nil
  end
end
