class Heartbeat
  def initialize(device_secret)
    @key = "devices:heartbeat:#{device_secret}"
  end

  def save
    Redis.current.set(@key, Time.now.to_i)
    true
  end
end
