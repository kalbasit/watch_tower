module WatchTower
  class Project
    module AnyBased
      def self.included(base)
        base.send :include, InstanceMethods
      end

      module InstanceMethods
        attr_reader :name, :path
      end
    end
  end
end