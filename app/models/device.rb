class Device < ApplicationRecord
  include Redis::Objects

  belongs_to :user
  belongs_to :app
  has_many :envvars, class_name: 'Envvar', dependent: :destroy
  sorted_set :log

  DEVICE_NAME_REGEX = /\A[a-zA-Z][a-zA-Z0-9\-\_]*\z/
  validates :user, presence: true
  validates :device_secret, presence: true
  validates :name, uniqueness: { scope: :user }, presence: true,
            format: { with: DEVICE_NAME_REGEX }
  validates :board, inclusion: { in: SUPPORTED_BOARDS }
  validates :status, inclusion: { in: DEVICE_STATUSES }

  def log_messages(since=0)
    self.log.rangebyscore(since, Float::INFINITY) || []
  end

  def update_status(status, log)
    self.heartbeated_at = Time.now
    self.status = status
    self.save!

    app = self.app
    time = Time.now.to_f
    lines = log.split("\n")

    lines.each_with_index do |line, index|
      self.log["#{time}:#{index}:#{line}"] = time
    end

    self.log.remrangebyrank(0, -LOGGING_MAX_LINES)

    if app
      device_name = self.name
      lines.each_with_index do |line, index|
        app.log["#{time}:#{index}:#{device_name}:#{line}"] = time
      end

      app.log.remrangebyrank(0, -LOGGING_MAX_LINES)
    end
  end

  def get_deployment!(deployment_id = nil)
    unless self.app
      return nil
    end

    if deployment_id
      deployment = Deployment.find_by_id!(deployment_id)

      if self.app != deployment.app or
         deployment.board != self.board or
         (deployment.tag != nil and deployment.tag != device.tag)

        return nil
      end

      deployment
    else
      # latest deployment
      Deployment.where(app: self.app, board: self.board,
                       tag: [self.tag, nil]).order("created_at").last
    end
  end

  def envvars_index
    self.envvars.select('name', 'value').all
  end
end
