backend:  bundle exec rails server
sidekiq:  bundle exec sidekiq -C ./config/sidekiq.yml
cron:     bundle exec cron:test
redis:    redis-server config/redis.development.conf
frontend: SERVER_URL=http://localhost:3000 PORT=8080 npm run watch
