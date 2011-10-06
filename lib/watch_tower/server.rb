SERVER_PATH = File.expand_path(File.join(File.dirname(__FILE__), 'server'))
MODELS_PATH = File.join(SERVER_PATH, 'models')
MIGRATIONS_PATH = File.join(SERVER_PATH, 'db', 'migrate')

module WatchTower
  module Server
    extend ::ActiveSupport::Autoload

    autoload :Project, ::File.join(MODELS_PATH, 'project.rb')
    autoload :File, ::File.join(MODELS_PATH, 'file.rb')
    autoload :TimeEntry, ::File.join(MODELS_PATH, 'time_entry.rb')
    autoload :App
    autoload :Database

    # Connect to the Database
    Database.connect!

    # Migrate the database
    Database.migrate!
  end
end