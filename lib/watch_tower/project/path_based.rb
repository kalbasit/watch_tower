module WatchTower
  class Project
    # The module contains Path specific project methods, methods like name, path
    # The module can be included into another module/class or used on it's own,
    # it does extend itself so any methods defined here is available to both class
    # and instance level
    module PathBased
      include AnyBased
      extend self

      # Cache for working_directory by path
      # The key is the path to a file, the value is the working directory of
      # this path
      @@working_cache = Hash.new

      # Cache for project_name by path
      # The key is the path to a file, the value is the project's name
      @@project_name_cache = Hash.new

      # Cache for project path parts
      # The key is the path to a file, the value is the project's parts
      @@project_path_part_cache = Hash.new

      # Return the working directory (the project's path if you will) from a path
      # to any file inside the project
      #
      # @param [String] path The path to look the project path from
      # @param [Hash] options A hash of options
      # @return [String] the project's folder
      def working_directory(path, options = {})
        return @@working_cache[path] if @@working_cache.key?(path)


        @@working_cache[path] = project_path_from_nested_path(code_path(options),
          path, nested_project_layers(options))
        @@working_cache[path]
      end

      # Return the project's name from a path to any file inside the project
      #
      # @param path The path to look the project path from
      # @param [Hash] options A hash of options
      # @return [String] the project's name
      def project_name(path, options = {})
        return @@project_name_cache[path] if @@project_name_cache.key?(path)

        @@project_name_cache[path] = project_name_from_nested_path(code_path(options),
          path, nested_project_layers(options))
        @@project_name_cache[path]
      end

      protected

        # Get the code path from the options, if not found use the one from the
        # configurations
        #
        # @param [Hash] options
        # @return [String] The Code path
        def code_path(options = {})
          options[:code_path] || Config[:code_path]
        end

        # Get the nested_project_layers from the options, if not found use the
        # one from the configurations
        #
        # @param [Hash] options
        # @return [String] The nested_project_layers
        def nested_project_layers(options = {})
          options[:nested_project_layers] || Config[:nested_project_layers]
        end

        # Taken from timetap
        # https://github.com/elia/timetap/blob/master/lib/time_tap/project.rb#L40
        #
        # Find out the path parts of the project that's currently being worked on,
        # under the code path, it uses the param nested_project_layers to determine
        # the project name from the entire expanded path to any file under the
        # project
        #
        # nested project layers works "how many folders inside your code folder
        # do you keep projects.
        #
        # For example, if your directory structure looks like:
        # ~/Code/
        #    Clients/
        #        AcmeCorp/
        #            website/
        #            intranet
        #        BetaCorp/
        #           skunkworks/
        #    OpenSource/
        #        project_one/
        #        timetap/
        #
        # A nested_project_layers setting of 2 would mean we track "AcmeCorp", "BetaCorp", and everything
        # under OpenSource, as their own projects
        #
        # @param code The path you store all the projects under
        # @param path The path to look the project name from
        # @param nested_project_layers How many folders, defaults to 2
        # @return [Array] The project path's parts
        # @raise [WatchTower::PathNotUnderCodePath] if the path is not nested under code
        def project_path_part(code, path, nested_project_layers = 2)
          return @@project_path_part_cache[path] if @@project_path_part_cache.key?(path)

          # Expand pathes
          code = expand_path code
          path = expand_path path

          regex_suffix = "([^/]+)"
          regex_suffix = [regex_suffix] * nested_project_layers
          regex_suffix = regex_suffix.join("/")

          path.scan(%r{(#{code})/#{regex_suffix}}).flatten.collect(&:chomp).
            tap { |r| raise PathNotUnderCodePath unless r.any? }.
            tap { |ppp| @@project_path_part_cache[path] = ppp }
        end

        # Find out the project's name
        # See #project_path_part
        #
        # @param code The path you store all the projects under
        # @param path The path to look the project name from
        # @param nested_project_layers How many folders, defaults to 2
        # @return [String] The project's name
        # @raise [WatchTower::PathNotUnderCodePath] if the path is not nested under code
        def project_name_from_nested_path(code, path, nested_project_layers = 2)
          project_path_part(code, path, nested_project_layers)[nested_project_layers]
        end

        # Find out the project's path
        # See #project_path_part
        #
        # @param code The path you store all the projects under
        # @param path The path to look the project name from
        # @param nested_project_layers How many folders, defaults to 2
        # @return [String] The project's path
        # @raise [WatchTower::PathNotUnderCodePath] if the path is not nested under code
        def project_path_from_nested_path(code, path, nested_project_layers = 2)
          project_path_part(code, path, nested_project_layers)[0..nested_project_layers].join('/')
        end
    end
  end
end