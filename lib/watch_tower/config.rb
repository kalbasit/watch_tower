# -*- encoding: utf-8 -*-

require 'active_support/hash_with_indifferent_access'

module WatchTower
  module Config
    extend self

    # Define the config class variable
    @@config = nil

    # Return a particular config variable from the parsed config file
    #
    # @param [String|Symbol] config
    # @return mixed
    # @raise [Void]
    def [](config)
      if @@config.nil?
        check_config_file
        @@config ||= HashWithIndifferentAccess.new(YAML.parse_file(config_file).to_ruby)
      end

      @@config[:watch_tower].send(:[], config)
    end

    # Get the config file
    #
    # @return [String] Absolute path to the config file
    def config_file
      File.join(USER_PATH, 'config.yml')
    end

    protected
      # Initialize the configuration file
      def initialize_config_file
        File.open(config_file, 'w') do |f|
          f.write(File.read(File.join(TEMPLATE_PATH, 'config.yml')))
        end
      end

      # Check the config file
      def check_config_file
        # Check that config_file is defined
        raise ConfigNotDefinedError unless config_file
        # Check that the config file exists
        initialize_config_file unless ::File.exists?(config_file)
        # Check that the config file is readable?
        raise ConfigNotReadableError unless ::File.readable?(config_file)
      end
  end
end
