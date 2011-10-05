module WatchTower
  class Project
    module GitBased
      def self.included(base)
        base.send :include, InstanceMethods
      end

      module InstanceMethods
      end
    end
  end
end