require 'watch_tower/git'

module WatchTower
  class Project
    module Init
      def self.included(base)
        base.extend ClassMethods
        base.send :include, InstanceMethods
      end

      module ClassMethods
        def new_from_path(path)
          if Git.active_for_path?(path)
            Project.send :include, Project::GitBased
            Project.new Git.project_name(path), Git.working_directory(path)
          else
            Project.send :include, Project::PathBased
            Project.new Path.project_name(path), Path.working_directory(path)
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