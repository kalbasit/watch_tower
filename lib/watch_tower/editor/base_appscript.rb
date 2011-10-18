require 'watch_tower/appscript'

module WatchTower
  module Editor
    module BaseAppscript
      def self.included(base)
        base.send :include, InstanceMethods
      end

      module InstanceMethods
        def self.included(base)
          base.class_eval <<-END, __FILE__, __LINE__ + 1
            # Include AppScript
            include ::Appscript

            def is_running?
              editor.is_running? if editor
            end

            # Returns the name of the editor
            #
            # Child class should implement this method
            def name
              editor.try(:name).try(:get)
            end

            def current_path
              current_paths.try(:first)
            end

            def current_paths
              if is_running?
                editor.document.get.collect(&:path).collect(&:get)
              end
            end
          END
        end
      end
    end
  end
end