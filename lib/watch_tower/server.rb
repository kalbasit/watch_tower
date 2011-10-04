SERVER_PATH = File.expand_path(File.join(File.dirname(__FILE__), 'server'))
MODELS_PATH = File.join(SERVER_PATH, 'models')
MIGRATIONS_PATH = File.join(SERVER_PATH, 'db', 'migrate')

# Open the connection
require 'watch_tower/server/database'

module WatchTower
  module Server
    extend ::ActiveSupport::Autoload

    autoload :TimeEntries, File.join(MODELS_PATH, 'time_entries.rb')
    autoload :App
  end
end