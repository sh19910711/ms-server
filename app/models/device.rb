class Device < ApplicationRecord
  include Redis::Objects

  belongs_to :user
  belongs_to :app
  has_many :envvars, class_name: 'Envvar', dependent: :destroy

  value :heartbeat
  value :status
  sorted_set :log

  DEVICE_NAME_REGEX = /\A[a-zA-Z][a-zA-Z0-9\-\_]*\z/
  validates :user, presence: true
  validates :device_secret, presence: true
  validates :name, uniqueness: { scope: :user }, presence: true,
            format: { with: DEVICE_NAME_REGEX }
  validates :board, inclusion: { in: SUPPORTED_BOARDS }

  def self.index
    devices = []
    self.find_each do |device|
      devices << device.slice(*%i[device_secret name board tag status])
    end

    devices
  end

  def log_messages(since=0)
    self.log.rangebyscore(since, Float::INFINITY) || []
  end

  def update_status(status, log)
    device_secret = self.device_secret
    self.heartbeat = Time.now.to_i
    self.status = status

    time = Time.now.to_f
    log.split("\n").each_with_index do |line, index|
      self.log["#{time}:#{index}:#{line}"] = time
    end

    self.log.remrangebyrank(0, -LOGGING_MAX_LINES)
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
