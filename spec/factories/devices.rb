FactoryGirl.define do
  factory :device do
    user
    name          { FFaker::Internet.domain_word }
    board         'esp8266'
    device_secret { Digest::SHA1.hexdigest(FFaker::Internet.email) }
    status        'new'
    device_secret_prefix { device_secret[0, DEVICE_SECRET_PREFIX_LEN] }
  end
end
