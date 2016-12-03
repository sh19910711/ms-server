FactoryGirl.define do
  factory :envvar do
    device
    name   { FFaker::Internet.domain_word.upcase }
    value  { FFaker::Airline.flight_number }
  end
end
