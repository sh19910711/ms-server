ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require "rspec/json_expectations"
require 'support/fixture'
require 'support/factory_girl'
require 'support/api'


RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include ActiveJob::TestHelper

  config.infer_base_class_for_anonymous_controllers = false
  config.render_views = true
end
