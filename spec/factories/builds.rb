FactoryGirl.define do
  factory :build do
    app
    status  'queued'
    source_file { open(Fixture.filepath('apps/led-blink.zip')).read }
  end
end
