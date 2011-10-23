# -*- encoding: utf-8 -*-

module WatchTower
  module Server
    module Helpers
      module Presenters

        def self.included(base)
          base.send :include, InstanceMethods
        end

        module InstanceMethods

          # Define partial as a helper
          helpers do
            # Present an object
            # Usually called with a block, the method yields the presenter into
            # the block
            #
            # @param [ActiveRecord::Base] Object: The model to present
            # @param [Nil | Object] klass: The klass to present
            def present(object, klass = nil)
              klass ||= "::WatchTower::Server::Presenters::#{object.class.to_s.split('::').last}Presenter".constantize
              presenter = klass.new(object, self)
              yield presenter if block_given?
              presenter
            end
          end
        end
      end
    end
  end
end