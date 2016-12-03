FactoryGirl.define do
  sequence(:name) { FFaker::Internet.domain_word }

  factory :app do
    user
    name
    max_heartbeat_interval { 60 }
  end
end
