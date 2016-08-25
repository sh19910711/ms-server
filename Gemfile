source 'https://rubygems.org'

gem 'rails', '~> 5.0.0'
gem 'sqlite3'
gem 'puma', '~> 3.0'
gem 'carrierwave'

group :development, :test do
  gem 'pry-rails'
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.5'
  gem "codeclimate-test-reporter", require: false
end

group :development do
  gem 'listen', '~> 3.0.5'

#  XXX: With sprig the following error ocurrs:
#  spring-1.7.2/lib/spring/application.rb:108:in `ensure in preload':
#  undefined method `application' for Rails:Module (NoMethodError)
#  gem 'spring'
#  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
