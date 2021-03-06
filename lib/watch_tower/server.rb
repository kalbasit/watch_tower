# -*- encoding: utf-8 -*-

module WatchTower
  module Server
    extend ::ActiveSupport::Autoload

    autoload :Database
    autoload :Duration, ::File.join(MODELS_PATH, 'duration.rb')
    autoload :Project, ::File.join(MODELS_PATH, 'project.rb')
    autoload :File, ::File.join(MODELS_PATH, 'file.rb')
    autoload :TimeEntry, ::File.join(MODELS_PATH, 'time_entry.rb')
    autoload :Helpers
    autoload :Configurations
    autoload :Presenters
    autoload :App

    # Start the server
    # This method starts the database and then starts the server
    #
    # @param [Hash] options
    def self.start(options = {})
      # Start the Database
      Database.start!(options)

      # Start the Sinatra application
      start_web_server(options)
    end

    # Start the Server, a method invoked from the Watch Tower command line interface
    #
    # @param [Hash] options
    def self.start!(options = {})
      start(options)
    end

    protected
      # Start the web_server
      # This method starts the web server (The Sinatra app)
      #
      # @param [Hash] options
      def self.start_web_server(options = {})
        LOG.debug("#{__FILE__}:#{__LINE__}: Starting the Sinatra App")

        # Abort execution if the Thread raised an error.
        Thread.abort_on_exception = true

        WatchTower.threads[:web_server] = Thread.new do
          LOG.debug("#{__FILE__}:#{__LINE__}: Starting a new Thread for the web server.")

          # Signal handling
          Signal.trap("INT")  { exit }
          Signal.trap("TERM") { exit }

          begin
            LOG.debug("#{__FILE__}:#{__LINE__}: Starting the web server in the new Thread.")

            # Start the server
            App.run!(options)

            LOG.debug("#{__FILE__}:#{__LINE__}: The server has stopped.")

            # Exit this thread immediately
            exit
          rescue => e
            LOG.fatal "#{__FILE__}:#{__LINE__ - 4}: #{e}" unless e.message == 'exit'
            raise e
          end
        end
      end
  end
end
