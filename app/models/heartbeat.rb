class Heartbeat
  def initialize(**args)
    # TODO: add a validation
    @key = "devices:heartbeat:#{args[:device_secret]}"
  end

  def save
    Redis.current.set(@key, Time.now.to_i)
    true
  end
end
