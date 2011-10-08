module WatchTower
  module Server
    module Database
      extend self

      # Start the database server
      #
      # see #connect!
      # see #migrate!
      # @param [Hash] options
      def start!(options = {})
        # Connect to the Database
        connect!

        # Migrate the database
        migrate!
      rescue DatabaseConfigNotFoundError
        STDERR.puts "Database configurations are missing, please edit #{Config::CONFIG_FILE} and try again."
        exit(1)
      rescue RuntimeError => e
        STDERR.puts e
        exit(1)
      end

      # Stop the database server
      #
      # see #disconnect!
      # @param [Hash] options
      def stop!(options = {})
        # Disconnect from the database
        disconnect!
      rescue DatabaseConfigNotFoundError
        STDERR.puts "Database configurations are missing, please edit #{Config::CONFIG_FILE} and try again."
        exit(1)
      rescue RuntimeError => e
        STDERR.puts e
        exit(1)
      end

      protected
        # Connect to the database
        def connect!
          # Create a connection
          ActiveRecord::Base.establish_connection(db_config)

          # Create a looger
          logger unless ENV['WATCH_TOWER_ENV'] == 'production'
        end

        # Disconnect from the database
        # TODO: Implement this function
        def disconnect!
          raise NotImplementedError
        end

        # Migrate the database
        def migrate!
          # Connect to the database
          connect!

          # Migrate the database
          ActiveRecord::Migrator.migrate(MIGRATIONS_PATH)
        end

        # Get the database configuration
        def db_config
          db_config = Config.try(:[], :database).try(:[], ENV['WATCH_TOWER_ENV'])
          raise DatabaseConfigNotFoundError unless db_config
          if db_config[:adapter] =~ /sqlite/ && db_config[:database] != ":memory:"
            db_config[:database] = ::File.expand_path(db_config[:database])
          end
          db_config
        end

        # Set the logger
        def logger
          ActiveRecord::Base.logger = Logger.new ::File.open(log_path, 'a')
        end

        # Get the log file's absolute path
        #
        # @return [String] The database log file depending on the environment
        def log_path
          ::File.join(LOG_PATH, "#{ENV['WATCH_TOWER_ENV']}_database.log")
        end
    end
  end
end