module WatchTower
  module Path
    extend self

    # TODO: Shouldn't hardcode these, actually they are just for tests
    #       They should be in a haml config file
    CODE_PATH = '~/Projects'

    # Return the working directory (the project's path if you will) from a path
    # to any file inside the project
    #
    # @param path The path to look the project path from
    # @return [String] the project's folder
    def working_directory(path)
      project_path_from_nested_path(path)
    end

    protected

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
      #
      # under OpenSource, as their own projects
      # Taken from timetap
      # https://github.com/elia/timetap/blob/master/lib/time_tap/project.rb#L40
      #
      # @param code The path you store all the projects under
      # @param path The path to look the project name from
      # @param nested_project_layers How many folders, defaults to 2
      # @return [Array] The project path's parts
      # @raise [WatchTower::PathNotUnderCodePath] if the path is not nested under code
      def project_path_part(code, path, nested_project_layers = 2)
        regex_suffix = "([^/]+)"
        regex_suffix = [regex_suffix] * nested_project_layers
        regex_suffix = regex_suffix.join("/")

        path.scan(%r{(#{code})/#{regex_suffix}}).flatten.collect(&:chomp).
          tap { |r| raise PathNotUnderCodePath unless r.any? }
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