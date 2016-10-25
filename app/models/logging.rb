class Logging
  def initialize(**args)
    @device_secret = args[:device_secret]
    @lines = args[:lines]
    @time = Time.now.to_i
    @key = "devices:logging:#{@device_secret}"
  end

  def save
    @lines.each do |line|
      Redis.current.rpush(@key, "#{@time}:#{line}")
    end

    Redis.current.ltrim(@key, 0, LOGGING_MAX_LINES - 1)
    true
  end


  def get
    # We assumes that the @key has been LTRIMed.
    Redis.current.lrange(@key, 0, -1)
  end
end
