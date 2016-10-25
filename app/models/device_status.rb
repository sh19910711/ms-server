class DeviceStatus
  attr_accessor :device_secret, :status

  def initialize(**args)
    @device_secret = args[:device_secret]
    @status = args[:status]
    @key = "devices:status:#{@device_secret}"
  end

  def validate
    DEVICE_STATUSES.include?(@status)
  end

  def save
    unless validate
      return false
    end

    Redis.current.set(@key, @status)
    true # TODO: error handling
  end

  def get!
    Redis.current.get(@key)
    # TODO: error handling
  end
end
