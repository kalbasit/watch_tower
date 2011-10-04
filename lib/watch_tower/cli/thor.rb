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
            desc "Watch Tower watches over your editors and record your activites per project"

            class_option :foreground,
              type: :boolean,
              required: false,
              aliases: "-f",
              default: false,
              desc: "Do not run in the background."
          END
        end
      end
    end
  end
end