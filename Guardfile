# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'bundler' do
  watch('Gemfile')
  watch(/^.+\.gemspec/)
end

guard 'rspec', :version => 2 do
  # All specs
  watch(%r{^spec/.+_spec\.rb$})
  watch('spec/spec_helper.rb')  { "spec" }
  watch(%r{spec/factories/(.+)\.rb} ) { "spec" }
  watch(%r{spec/support/(.+)\.rb} ) { "spec" }

  # Server
  watch(%r(^lib/watch_tower/server/(views|extensions|presenters)/(.+)$)) { "spec/watch_tower/server/app_spec.rb" }
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
end
