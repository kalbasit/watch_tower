require 'sqlite3'
require 'active_record'
require 'yaml'

# Create a connection
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: File.join(USER_PATH, 'database.sqlite3'),
  pool: 5,
  timeout: 5000
)

# Create a logger
ActiveRecord::Base.logger = Logger.new(File.open(File.join(USER_PATH, 'database.log'), 'a'))

# Migrate the database
ActiveRecord::Migrator.migrate(MIGRATIONS_PATH)