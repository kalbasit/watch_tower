SERVER_PATH = File.expand_path(File.join(File.dirname(__FILE__), 'server'))
MODELS_PATH = File.join(SERVER_PATH, 'models')
MIGRATIONS_PATH = File.join(SERVER_PATH, 'db', 'migrate')

# Active Record
require 'active_record'

module WatchTower
  module Server
    extend ::ActiveSupport::Autoload

    autoload :Duration, ::File.join(MODELS_PATH, 'duration.rb')
    autoload :Project, ::File.join(MODELS_PATH, 'project.rb')
    autoload :File, ::File.join(MODELS_PATH, 'file.rb')
    autoload :TimeEntry, ::File.join(MODELS_PATH, 'time_entry.rb')
    autoload :App
    autoload :Database

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
      @thread ||= Thread.new do
        # Trap INT and TERM to quit the thread
        Signal.trap("INT")  { exit }
        Signal.trap("TERM") { exit }

        # Start the server
        start(options)

        # Exit right after the loop ended (for some reason)
        exit
      end
    end

    protected
      # Start the web_server
      # This method starts the web server (The Sinatra app)
      #
      # @param [Hash] options
      def self.start_web_server(options = {})
        App.run!(options)
      end
  end
end