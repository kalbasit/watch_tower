# -*- encoding: utf-8 -*-

module WatchTower
  class Project
    module AnyBased

      def self.included(base)
        base.send :include, InstanceMethods
        base.extend ClassMethods
      end

      module InstanceMethods
        attr_reader :name, :path
      end

      module ClassMethods
        protected
          def expand_path(path)
            File.expand_path(path)
          end
      end
    end
  end
end