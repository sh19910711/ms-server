if Rails.env.development? || Rails.env.test?
  Redis.current = Redis.new(url: 'redis://127.0.0.1:6379')
else
  Redis.current = Redis.new(url: ENV['REDIS_URL'])
end
