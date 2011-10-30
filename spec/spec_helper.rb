# -*- encoding: utf-8 -*-
$:.push File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))

ENV['WATCH_TOWER_ENV'] = 'test'

require 'rubygems'
require 'rspec'

# Require the library
require 'watch_tower'

include WatchTower

# Require support files
Dir[ROOT_PATH + "/spec/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  # config.mock_with :rspec

  # Treat symbols as metadata keys with true values
  config.treat_symbols_as_metadata_keys_with_true_values = true
end
