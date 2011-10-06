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

    begin
      # Connect to the Database
      Database.connect!

      # Migrate the database
      Database.migrate!
    rescue DatabaseConfigNotFoundError
      STDERR.puts "Database configurations are missing, please edit #{Config::CONFIG_FILE} and try again."
      exit(1)
    rescue RuntimeError => e
      STDERR.puts e
      exit(1)
    end
  end
end