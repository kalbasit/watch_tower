module WatchTower
  class Project
    module PathBased
      def self.included(base)
        base.send :include, InstanceMethods
      end

      module InstanceMethods
      end
    end
  end
end