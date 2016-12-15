FactoryGirl.define do
  factory :deployment do
    app
    build
    board 'esp8266'
    image 'abcdefghijklmn'
    released_at { Time.now }
  end
end
