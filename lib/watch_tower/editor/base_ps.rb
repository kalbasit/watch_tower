module WatchTower
  module Editor
    module BasePs
      def self.included(base)
        base.send :include, InstanceMethods
      end

      module InstanceMethods
        def self.included(base)
          base.class_eval <<-END, __FILE__, __LINE__ + 1
            # Returns the name of the editor
            #
            # Child class should implement this method
            def name
              raise NotImplementedError, "Please define this function in your class."
            end

            # Returns the version of the editor
            #
            # Child class should implement this method
            def version
              raise NotImplementedError, "Please define this function in your class."
            end
          END
        end
      end
    end
  end
end