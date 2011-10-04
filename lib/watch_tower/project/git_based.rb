module WatchTower
  class Project
    module GitBased
      def self.included(base)
        base.send :include, InstanceMethods
      end

      module InstanceMethods
        class_eval <<-END, __FILE__, __LINE__ + 1
          def name
          end

          def path
          end
        END
      end
    end
  end
end