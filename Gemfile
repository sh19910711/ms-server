source 'https://rubygems.org'

gem 'rails', '5.0.0.1'
gem 'puma', '~> 3.0'
gem 'carrierwave'

gem 'sqlite3', group: :sqlite
gem 'mysql2', '~> 0.3.16', group: :mysql
gem 'pg', '~> 0.18.2', group: :postgres

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :development, :test do
  gem 'pry-rails'
  gem 'byebug', platform: :mri
end

group :test do
  gem 'rspec-rails', '~> 3.5'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'codeclimate-test-reporter', require: false
  gem 'guard-rspec', require: false
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
