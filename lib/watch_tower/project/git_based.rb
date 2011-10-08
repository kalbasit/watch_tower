require 'git'

module WatchTower
  class Project
    module GitBased
      extend self
      include AnyBased

      # Cache for working_directory by path
      # The key is the path to a file, the value is the working directory of
      # this path
      @@working_cache = Hash.new

      # Cache for project_name by path
      # The key is the path to a file, the value is the project's name
      @@project_name_cache = Hash.new

      # Cache for project git path
      # The key is the path to a file, the value is the project's parts
      @@project_git_folder_path = Hash.new

      # Check if the path is under Git
      #
      # @param path The path we should check if it's under Git control
      # @param [Hash] options A hash of options
      # @return boolean
      def active_for_path?(path, options = {})
        path = expand_path path rescue nil
        project_git_folder_path(path).present?
      end

      # Return the working directory (the project's path if you will) from a path
      # to any file inside the project
      #
      # @param path The path to look the project path from
      # @param [Hash] options A hash of options
      # @return [String] the project's folder
      def working_directory(path, options = {})
        path = expand_path path
        return @@working_cache[path] if @@working_cache.key?(path)

        @@working_cache[path] = File.dirname(project_git_folder_path(path))
        @@working_cache[path]
      end

      # Return the project's name from a path to any file inside the project
      #
      # @param path The path to look the project path from
      # @param [Hash] options A hash of options
      # @return [String] the project's name
      def project_name(path, options = {})
        path = expand_path path
        return @@project_name_cache[path] if @@project_name_cache.key?(path)

        @@project_name_cache[path] = File.basename working_directory(path, options)
        @@project_name_cache[path]
      end

      def head(path)
        log(path)
      end

      def log(path)
        g = ::Git.open path
        g.log.first
      end

      protected
        def project_git_folder_path(path)
          return @@project_git_folder_path[path] if @@project_git_folder_path.key?(path)

          # Define the start
          n = 0
          # Define the maximum search folder
          max_n = path.split('/').size

          until File.exists?(File.expand_path File.join(path, (%w{..} * n).flatten, '.git')) || n > max_n
            n = n + 1
          end

          @@project_git_folder_path[path] = n <= max_n ? File.expand_path(File.join(path, (%w{..} * n).flatten, '.git')) : nil
          @@project_git_folder_path[path]
        end
    end
  end
end