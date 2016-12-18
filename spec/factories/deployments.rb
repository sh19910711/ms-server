FactoryGirl.define do
  factory :deployment do
    app
    board 'esp8266'
    image 'abcdefghijklmn'
    status 'queued'
    released_at { Time.now }
  end
end
