require 'sqlite3'
require 'active_record'
require 'yaml'

ENV['WATCH_TOWER_ENV'] ||= 'development'

# Create a connection
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: File.join(DATABASE_PATH, "#{ENV['WATCH_TOWER_ENV']}.sqlite3"),
  pool: 5,
  timeout: 5000
)

# Create a logger
log_path = File.join(LOG_PATH, "#{ENV['WATCH_TOWER_ENV']}_database.log")
ActiveRecord::Base.logger = Logger.new File.open(log_path, 'a') unless
  ENV['WATCH_TOWER_ENV'] == 'production'

# Migrate the database
ActiveRecord::Migrator.migrate(MIGRATIONS_PATH)