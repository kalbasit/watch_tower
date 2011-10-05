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
            extend ::Appscript

            def is_running?
              @@app.try(:is_running?)
            end

            def current_path
              if is_running?
                # Get the document
                document = @@app.document.get

                document.first.path.get rescue nil
              end
            end
          END
        end
      end
    end
  end
end