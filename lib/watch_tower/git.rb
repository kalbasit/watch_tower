require 'git'

module WatchTower
  module Git
    extend self

    # Check if the path is under Git
    #
    # @param path The path we should check if it's under Git control
    # @param [Hash] options A hash of options
    # @return boolean
    def active_for_path?(path, options = {})
      git_folder_path(path).present?
    end

    # Return the working directory (the project's path if you will) from a path
    # to any file inside the project
    #
    # @param path The path to look the project path from
    # @param [Hash] options A hash of options
    # @return [String] the project's folder
    def working_directory(path, options = {})
      File.dirname(git_folder_path(path))
    end

    # Return the project's name from a path to any file inside the project
    #
    # @param path The path to look the project path from
    # @param [Hash] options A hash of options
    # @return [String] the project's name
    def project_name(path, options = {})
      File.basename working_directory(path, options)
    end

    def head(path)
      log(path)
    end

    def log(path)
      g = ::Git.open path
      g.log.first
    end

    protected
      def git_folder_path(path)
        # Define the start
        n = 0
        # Define the maximum search folder
        max_n = path.split('/').size

        until File.exists?(File.expand_path File.join(path, (%w{..} * n).flatten, '.git')) || n > max_n
          n = n + 1
        end

        if n <= max_n
          File.expand_path File.join(path, (%w{..} * n).flatten, '.git')
        else
          nil
        end
      end
  end
end