module WatchTower
  class Project
    module Init
      def self.included(base)
        base.extend ClassMethods
        base.send :include, InstanceMethods
      end

      module ClassMethods
        def new_from_path(path)
          if GitBased.active_for_path?(path)
            Project.new GitBased.project_name(path), GitBased.working_directory(path)
          else
            Project.new PathBased.project_name(path), PathBased.working_directory(path)
          end
        end
      end

      module InstanceMethods
        def initialize(name, path)
          @name = name
          @path = path
        end
      end
    end
  end
end