FactoryGirl.define do
  factory :user do
    name     { FFaker::Internet.user_name }
    email    { FFaker::Internet.email }
    confirmed_at { Time.now }
    password '12345678'
  end
end
