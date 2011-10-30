# -*- encoding: utf-8 -*-

module WatchTower
  module CLI
    module Version

      def self.included(base)
        base.send :include, InstanceMethods
      end

      module InstanceMethods
        def self.included(base)
          base.class_eval <<-END, __FILE__, __LINE__ + 1
            desc "version", "Prints watchtower version and exits."
            def version
              puts "WatchTower version \#{WatchTower.version}"
            end
          END
        end
      end
    end
  end
end
