$:.push File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
require 'watch_tower'

guard 'bundler' do
  watch('Gemfile')
  watch(/^.+\.gemspec/)
end

guard 'sprockets2',
  sprockets: WatchTower::Server::App.sprockets,
  assets_path: 'lib/watch_tower/server/public/assets' do
  watch(%r{^lib/watch_tower/server/assets/.+$})
  watch('lib/watch_tower/server/app.rb')
end

guard 'rspec', :version => 2 do
  # All specs
  watch(%r{^spec/.+_spec\.rb$})
  watch('spec/spec_helper.rb')  { "spec" }
  watch(%r{spec/factories/(.+)\.rb} ) { "spec" }
  watch(%r{spec/support/(.+)\.rb} ) { "spec" }

  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r(^lib/watch_tower/server/(views|extensions|presenters)/(.+)$)) { "spec/watch_tower/server/app_spec.rb" }
end
