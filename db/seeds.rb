# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'factory_girl'
require 'ffaker'
require Rails.root.join('spec/support/fixture.rb')

Dir[Rails.root.join('spec/factories/*.rb')].each do |factory|
  require factory
end

user = FactoryGirl.create(:user, name: "luke", email: "luke@example.com")
app = FactoryGirl.create(:app, name: "starwars", user: user)
FactoryGirl.create(:device, name: "x-wing", device_secret: "abc", user: user)
build = FactoryGirl.create(:build, app: app, status: "success", log: "
>>> stage: Infra
>>> action: Build Environment Info
Hello
>>> action_end: success
>>> action: Pull Docker image
World
>>> action_end: success
>>> stage_end
>>> stage: Build
>>> action: Build System Info
Great
>>> action_end: fail
>>> action: Extract source .zip file
Again
!
>>> action_end: success
>>> action: Converting to a Resea app
America
>>> action_end: success
>>> action: Build an app image for ESP8266
foo
>>> action_end: fail
>>> stage_end
>>> stage: Deploy
>>> action: Collect app images
bar
>>> action_end: success
>>> action: Deploy an image for ESP8266
baz
>>> action_end: success
>>> stage_end
")

FactoryGirl.create(:deployment, comment: "first commit!", app: app, board: "esp8266",
                   released_at: Time.now, build: build)
