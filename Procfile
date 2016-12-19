backend: bundle exec rails server -p 3000
sidekiq: bundle exec sidekiq -C ./config/sidekiq.yml
cron:    bundle exec rails cron:test
redis:   redis-server config/redis.development.conf
ui:      npm run dev
