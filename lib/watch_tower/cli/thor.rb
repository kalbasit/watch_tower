require 'thor'
require 'thor/group'

module WatchTower
  module CLI
    module Thor

      def self.included(base)
        base.send :include, InstanceMethods
      end

      module InstanceMethods
        def self.included(base)
          base.class_eval <<-END, __FILE__, __LINE__ + 1
          END
        end
      end
    end
  end
end