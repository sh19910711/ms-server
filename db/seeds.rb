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
device = FactoryGirl.create(:device, name: "x-wing", device_secret: "abc", app: app,
                            user: user)

device.update_status("running", "
I> Hello World!
I> kmalloc: allocating 3KB
W> failed to allocate
I> switch to #1
I> switch to #2
I> switch to #3
I> switch to #1
I> switch to #6
I> switch to #3
I> switch to #1
I> switch to #5
I> switch to #3
I> switch to #3
I> switch to #2
I> switch to #1
I> switch to #2
I> switch to #7
I> switch to #3
I> switch to #4
I> switch to #5
I> switch to #6
I> switch to #7
")

FactoryGirl.create(:deployment, app: app, status: "success", comment: "first commit!",
                   board: "esp8266", released_at: Time.now, buildlog: "
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
>>> action_end: failure
>>> action: Extract source .zip file
Again
!
>>> action_end: success
>>> action: Converting to a Resea app
America
>>> action_end: success
>>> action: Build an app image for ESP8266
foo
>>> action_end: failure
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
