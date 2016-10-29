class Device < ApplicationRecord
  belongs_to :user
  belongs_to :app
  has_many :envvars, class_name: 'Envvar', dependent: :destroy

  DEVICE_NAME_REGEX = /\A[a-zA-Z][a-zA-Z0-9\-\_]*\z/
  validates :user, presence: true
  validates :device_secret, presence: true
  validates :name, uniqueness: { scope: :user }, presence: true,
            format: { with: DEVICE_NAME_REGEX }
  validates :board, inclusion: { in: SUPPORTED_BOARDS }

  after_save :save_status

  def self.index
    devices = []
    self.find_each do |device|
      devices << device.slice(*%i[device_secret name board tag status])
    end

    devices
  end

  def update_hearbeat(status, log)
    device_secret = self.device_secret
    heartbeat = Heartbeat.new(device_secret: device_secret)
    device_status = DeviceStatus.new(device_secret: device_secret, status: status)
    logging = Logging.new(device_secret: device_secret,
                          lines: log.split("\n"))

    unless [heartbeat.save, device_status.save, logging.save].all?
      logger.warn "failed to save to Redis"
      # ignore the error; BaseOS doesn't care about that
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

  def status
    DeviceStatus.new(device_secret: self.device_secret).get
  end

  def status=(status)
    @new_status = status
  end

  private

  def save_status
    if @new_status
      DeviceStatus.new(device_secret: self.device_secret,
                       status: @new_status).save
    end
  end
end
