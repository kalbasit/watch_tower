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
            include Project::GitBased
            Project.new Git.base_path_for_path(path)
          else
            include Project::PathBased
            Project.new Path.base_path_for_path(path)
          end
        end
      end

      module InstanceMethods
        def initialize(path)
          @path = path
          @name = File.basename(path)
        end
      end
    end
  end
end