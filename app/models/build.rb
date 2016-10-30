class Build < ApplicationRecord
  belongs_to :app
  validates :app, presence: true
  validates :status, inclusion: { in: BUILD_STATUSES }

  def save_and_enqueue!
    self.status = 'queued'
    self.save!

    BuildJob.perform_later(self.id)
  end
end
