FactoryGirl.define do
  factory :esp8266_new_device, class: 'Device' do
    name   'foo-device'
    board  'esp8266'
    status 'ready'
  end
end
