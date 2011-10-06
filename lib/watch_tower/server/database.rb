require 'active_record'

module WatchTower
  module Server
    module Database
      extend self

      def connect!
        # Create a connection
        ActiveRecord::Base.establish_connection(db_config)

        # Create a looger
        logger unless ENV['WATCH_TOWER_ENV'] == 'production'
      end

      def migrate!
        # Connect to the database
        connect!

        # Migrate the database
        ActiveRecord::Migrator.migrate(MIGRATIONS_PATH)
      end

      protected
        def db_config
          db_config = Config.try(:[], :database).try(:[], ENV['WATCH_TOWER_ENV'])
          raise DatabaseConfigNotFoundError unless db_config
          if db_config[:adapter] =~ /sqlite/
            db_config[:database] = ::File.expand_path(db_config[:database])
          end
          db_config
        end

        def logger
          ActiveRecord::Base.logger = Logger.new ::File.open(log_path, 'a')
        end

        def log_path
          ::File.join(LOG_PATH, "#{ENV['WATCH_TOWER_ENV']}_database.log")
        end
    end
  end
end