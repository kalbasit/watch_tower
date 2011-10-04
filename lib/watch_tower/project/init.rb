require 'watch_tower/git'

module WatchTower
  class Project
    module Init
      def self.included(base)
        base.send :include, InstanceMethods
      end

      module InstanceMethods
        class_eval <<-END, __FILE__, __LINE__ + 1
          def initialize(path)
            @path = path
            @name = File.basename(path)
          end

          def self.new_from_path(path)
            if Git.active_for_path?(path)
              include GitBased
              Project.new Git.base_path_for(path)
            else
              include PathBased
              Project.new Path.base_path_for(path)
            end
          end
        END
      end
    end
  end
end