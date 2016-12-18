class Deployment < ApplicationRecord
  belongs_to :app

  validates :app, presence: true
  validates :version, uniqueness: { scope: :app }
  validates :image, presence: true, if: :released?
  validates :board, inclusion: { in: SUPPORTED_BOARDS }, if: :released?
  validates :status, inclusion: { in: BUILD_STATUSES }

  before_create :set_versions

  def build
    BuildJob.perform_later(self.id)
  end

  def set_versions
    self.version = (Deployment.where(app: self.app).maximum(:version) || 0) + 1
  end

  def released?
    self.released_at != nil
  end
end
