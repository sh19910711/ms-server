FactoryGirl.define do
  factory :deployment do
    app
    board 'esp8266'
    image 'abcdefghijklmn'
  end
end
