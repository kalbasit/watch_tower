require 'capybara'
require 'capybara/dsl'

Capybara.app = WatchTower::Server::App

RSpec.configure do |config|
  config.include Capybara::DSL, :example_group => {
    :file_path => config.escaped_path(%w[spec watch_tower server])
  }
end