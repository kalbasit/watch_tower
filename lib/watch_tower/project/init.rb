module WatchTower
  class Project
    module Init
      def self.included(base)
        base.extend ClassMethods
        base.send :include, InstanceMethods
      end

      module ClassMethods
        # Create a new project from a path (to a file or a folder)
        #
        # @param [String] path, the path to the file
        # @return [Project] a new initialized project
        def new_from_path(path)
          if GitBased.active_for_path?(path)
            Project.new GitBased.project_name(path), GitBased.working_directory(path)
          else
            Project.new PathBased.project_name(path), PathBased.working_directory(path)
          end
        end
      end

      module InstanceMethods
        # Initialize a project using a name and a path
        #
        # @param [String] name: the name of the project
        # @param [String] path: The path of the project
        def initialize(name, path)
          @name = name
          @path = path
        end
      end
    end
  end
end