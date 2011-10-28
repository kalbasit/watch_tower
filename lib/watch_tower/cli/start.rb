# -*- encoding: utf-8 -*-

module WatchTower
  module CLI
    module Start

      def self.included(base)
        base.send :include, InstanceMethods
      end

      module InstanceMethods
        def self.included(base)
          base.class_eval <<-END, __FILE__, __LINE__ + 1
            # Mappings (aliases)
            map "-s" => :start

            # Start watchtower
            desc "start", "Start the Watch Tower"
            method_option :bootloader,
              type: :boolean,
              required: false,
              aliases: "-b",
              default: false,
              desc: "Is it invoked from the bootloader?"
            method_option :foreground,
              type: :boolean,
              required: false,
              aliases: "-f",
              default: false,
              desc: "Do not run in the background."
            method_option :host,
              type: :string,
              required: false,
              aliases: "-h",
              default: 'localhost',
              desc: "Set the server's host"
            method_option :port,
              type: :numeric,
              required: false,
              aliases: "-p",
              default: 9282,
              desc: "Set the server's port."
            method_option :debug,
              type: :boolean,
              required: false,
              aliases: "-d",
              default: false,
              desc: "Run in debug mode."
            def start
              # Set the logger to debug mode if necessary
              LOG.level = Logger::DEBUG if options[:debug]

              begin
                if Config[:enabled] &&
                  (!options[:bootloader] || (options[:bootloader] && Config[:launch_on_boot]))
                  LOG.info "#{__FILE__}:#{__LINE__}: Starting WatchTower."
                  start!
                  LOG.info "#{__FILE__}:#{__LINE__}: WatchTower has finished."
                else
                  abort "You need to edit the config file located at \#{Config.config_file}."
                end
              rescue ConfigNotReadableError => e
                LOG.fatal "#{__FILE__}:#{__LINE__}: The config file is not readable."
                STDERR.puts "The config file is not readable, please make sure \#{Config.config_file} exists and you have the necessary permissions to read it."
                exit(1)
              end
            end

            protected
              def start!
                if options[:foreground]
                  LOG.debug "#{__FILE__}:#{__LINE__}: Running WatchTower in foreground."

                  # Start WatchTower
                  start_watch_tower
                else
                  LOG.debug "#{__FILE__}:#{__LINE__}: Running WatchTower in the background."
                  pid = fork do
                    begin
                      # Try to replace ruby with WatchTower in the command line (for ps)
                      $0 = 'watchtower' unless $0 == 'watchtower'

                      # Tell ruby that we are a daemon
                      Process.daemon

                      # Start WatchTower
                      start_watch_tower
                    rescue => e
                      LOG.fatal "#{__FILE__}:#{__LINE__ - 2}: The process raised an exception \#{e.message}"
                      LOG.fatal "#{__FILE__}:#{__LINE__ - 3}: ==== Backtrace ===="
                      e.backtrace.each do |trace|
                        LOG.fatal "#{__FILE__}:#{__LINE__ - 5}: \#{trace}"
                      end
                    end
                  end
                end
              end

              # Start watch tower
              # This method just start the watch tower it doesn't know
              # or care if we are in a forked process or not, all it cares about
              # is starting the database server before starting the eye
              #
              # see #start_server
              # see #start_eye
              def start_watch_tower
                # Start the server
                start_server

                # Wait until the database starts
                until Server::Database.is_connected? do
                  sleep(1)
                end

                # Wait until the database has migrated
                until Server::Database.is_migrated? do
                  sleep(1)
                end

                # Start the eye now.
                start_eye
              end

              # Start the eye
              # This method just start the watch tower it doesn't know
              # or care if we are in a forked process or not
              def start_eye
                LOG.debug "#{__FILE__}:#{__LINE__}: Starting the eye."
                Eye.start!(watch_tower_options)
              end

              # Start the web server
              # This method just start the watch tower it doesn't know
              # or care if we are in a forked process or not
              def start_server
                LOG.debug "#{__FILE__}:#{__LINE__}: Starting the web server."
                Server.start!(watch_tower_options)
              end

              # Return Watch Tower options
              # same as options but modified to correspond to WatchTower options
              # instead of CLI options
              #
              # @return [Hash] options
              def watch_tower_options
                return @watch_tower_options if @watch_tower_options

                @watch_tower_options = options.dup
                @watch_tower_options.delete(:bootloader)

                # Log the options as a Debug
                LOG.debug "#{__FILE__}:#{__LINE__}: Options are \#{@watch_tower_options.inspect}."

                # Return the options
                @watch_tower_options
              end
          END
        end
      end
    end
  end
end
