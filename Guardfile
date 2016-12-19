guard :rspec, cmd: "bundle exec rspec", notification: false do
  require "guard/rspec/dsl"
  dsl = Guard::RSpec::Dsl.new(self)

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  # Ruby files
  ruby = dsl.ruby
  dsl.watch_spec_files_for(ruby.lib_files)

  # Rails files
  watch('spec/spec_helper.rb')                                      { "spec" }
  watch('app/controllers/application_controller.rb')                { "spec/controllers" }
  watch('config/routes.rb')                                         { "spec/routing" }
  watch(%r{^spec/factories/(.+).rb})                                { |m| "spec/factories_spec.rb" }
  watch(%r{^spec/support/(controllers|mailers|models)_helpers.rb})  { |m| "spec/#{m[1]}" }
  watch(%r{^app/controllers/(.+)_controller.rb})  { |m| "spec/controllers/#{m[1]}_controller_spec.rb" }
  watch(%r{^app/(.+).rb})                         { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/(.+).rb})                         { |m| "spec/lib/#{m[1]}_spec.rb" }
end
