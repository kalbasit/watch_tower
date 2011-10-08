module WatchTower
  module CLI
    module Open

      def self.included(base)
        base.send :include, InstanceMethods
      end

      module InstanceMethods
        def self.included(base)
          base.class_eval <<-END, __FILE__, __LINE__ + 1
            # Open the WatchTower server in the browser
            #
            # TODO: Should be able to determine the port of the server.
            desc "open", "Open the WatchTower in the browser"
            def open
              system "open http://localhost:9282"
            end
          END
        end
      end
    end
  end
end