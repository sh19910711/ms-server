class Build < ApplicationRecord
  belongs_to :app

  validates :app, presence: true
  validates :status, inclusion: { in: BUILD_STATUSES }

  def save_and_enqueue!(deployment)
    self.status = 'queued'
    self.save!

    BuildJob.perform_later(deployment.id, self.id)
  end
end
