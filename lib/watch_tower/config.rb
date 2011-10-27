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
      ensure_config_file_exists
      if config_file && File.exists?(config_file)
        @@config ||= HashWithIndifferentAccess.new(YAML.parse_file(config_file).to_ruby)
        @@config[:watch_tower].send(:[], config)
      end
    end

    # Get the config file
    #
    # @return [String] Absolute path to the config file
    def config_file
      File.join(USER_PATH, 'config.yml')
    end

    protected
      # Ensures config file exists in the user config folder
      #
      # @param [Void]
      # @return [Void]
      # @raise [Void]
      def ensure_config_file_exists
        unless config_file && File.exists?(config_file)
          File.open(config_file, 'w') do |f|
            f.write(File.read(File.join(TEMPLATE_PATH, 'config.yml')))
          end
        end
      end
  end
end