module WatchTower
  module CLI
    module Eye
      def self.included(base)
        base.send :include, InstanceMethods
      end

      module InstanceMethods
      end
    end
  end
end