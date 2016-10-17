source 'https://rubygems.org'

gem 'rails', '5.0.0.1'
gem 'puma', '~> 3.0'
gem 'devise'
gem 'devise_token_auth'
gem 'omniauth'
gem 'cancancan', '~> 1.10'
gem 'sidekiq'

gem 'mysql2', '~> 0.4.4', group: :mysql
gem 'pg', '~> 0.18.2', group: :postgres

gem 'rubyzip'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :development, :test do
  gem 'sqlite3'
  gem 'pry-rails'
  gem 'active_record_query_trace'
  gem 'rb-readline', require: false
  gem 'byebug', platform: :mri
end

group :test do
  gem 'rspec-rails', '~> 3.5'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'codeclimate-test-reporter', require: false
  gem 'guard-rspec', require: false
end

group :development do
  gem 'listen', '~> 3.1.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem "rails-erd", require: false
end
