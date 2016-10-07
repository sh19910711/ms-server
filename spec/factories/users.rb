FactoryGirl.define do
  factory :chandler, class: 'User' do
    name   'chandler'
    uid    'chandler@example.com'
    email  'chandler@example.com'
    password '12345678'
  end
end
