# -*- encoding: utf-8 -*-

module WatchTower
  module Server
    module Helpers
      module Asset

        def self.included(base)
          base.send :include, InstanceMethods
        end

        module InstanceMethods

          # Define partial as a helper
          helpers do
            # Get the asset path of a given source
            #
            # Code taken from
            # https://github.com/stevehodgkiss/sinatra-asset-pipeline/blob/master/app.rb#L11
            #
            # @param [String] The source file
            # @return [String] The path to the asset
            def asset_path(source)
              "/assets/" + settings.sprockets.find_asset(source).digest_path
            end
          end
        end
      end
    end
  end
end