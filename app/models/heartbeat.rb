class Heartbeat
  def initialize(device_secret)
    @key = "devices:hearbeat:#{device_secret}"
  end

  def save
    Redis.current.set(@key, Time.now.to_i)
    true # TODO: error handling
  end
end
