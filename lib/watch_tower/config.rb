module WatchTower
  module Config
    extend self

    # Define the config file's path
    CONFIG_FILE = File.join(USER_PATH, 'config.yml')

    # Define the config class variable
    @@config = nil

    def [](config)
      ensure_config_file_exists
      @@config ||= YAML.parse_file(CONFIG_FILE).to_ruby
      @@config[:watch_tower].send(:[], config)
    end

    protected
      # Ensures config file exists in the user config folder
      #
      # @params [Void]
      # @returns [Void]
      # @raises [Void]
      def ensure_config_file_exists
        unless File.exists?(CONFIG_FILE)
          File.open(CONFIG_FILE, 'w') do |f|
            f.write(File.read(File.join(TEMPLATE_PATH, 'config.yml')))
          end
        end
      end
  end
end