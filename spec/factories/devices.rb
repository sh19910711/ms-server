FactoryGirl.define do
  factory :device do
    user
    name          { FFaker::Internet.domain_word }
    board         'esp8266'
    device_secret { Digest::SHA1.hexdigest(FFaker::Internet.email) }
    status        'new'
  end
end
