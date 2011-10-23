# -*- encoding: utf-8 -*-

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

            # Is the editor running ?
            #
            # @return [Boolean]
            def is_running?
              editor.is_running? if editor
            end

            # Returns the name of the editor
            #
            # Child class should implement this method
            def name
              editor.try(:name).try(:get)
            end

            # Returns the version of the editor
            #
            # Child class should implement this method
            def version
              editor.try(:version).try(:get)
            end

            # Return the path of the document being edited
            # Child classes can override this method if the behaviour is different
            #
            # @return [String] path to the document currently being edited
            def current_path
              current_paths.try(:first)
            end

            # Return the pathes of the documents being edited
            # Child classes can override this method if the behaviour is different
            #
            # @return [Array] pathes to the documents currently being edited
            def current_paths
              if is_running? && editor.respond_to?(:document)
                editor.document.get.collect(&:path).collect(&:get)
              end
            end
          END
        end
      end
    end
  end
end