# -*- encoding: utf-8 -*-

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

            # The editor's name for the log
            # Child classes can overwrite this method
            #
            # @return [String]
            def to_s
              "\#{self.class.to_s.split('::').last} Editor"
            end
          END
        end
      end
    end
  end
end
