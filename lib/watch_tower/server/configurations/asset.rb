# Asset Pipeline
require 'coffee-script'
require 'uglifier'
require 'sass'
require 'sprockets'

module WatchTower
  module Server
    module Configurations
      module Asset
        def self.included(base)
          base.class_eval <<-END, __FILE__, __LINE__ + 1
            # Code taken from
            # https://github.com/stevehodgkiss/sinatra-asset-pipeline/blob/master/app.rb#L11
            set :sprockets, Sprockets::Environment.new(SERVER_PATH)
            set :precompile, [ /\w+\.(?!js|css).+/, /application.(css|js)$/ ]
            set :assets_prefix, 'assets'
            set :assets_path, ::File.join(SERVER_PATH, 'public', assets_prefix)

            configure do
              # Lib
              sprockets.append_path(::File.join(SERVER_PATH, 'lib', 'assets', 'stylesheets'))
              sprockets.append_path(::File.join(SERVER_PATH, 'lib', 'assets', 'javascripts'))
              sprockets.append_path(::File.join(SERVER_PATH, 'lib', 'assets', 'images'))

              # Vendor
              sprockets.append_path(::File.join(SERVER_PATH, 'vendor', 'assets', 'stylesheets'))
              sprockets.append_path(::File.join(SERVER_PATH, 'vendor', 'assets', 'javascripts'))
              sprockets.append_path(::File.join(SERVER_PATH, 'vendor', 'assets', 'images'))

              # Assets
              sprockets.append_path(::File.join(SERVER_PATH, 'assets', 'stylesheets'))
              sprockets.append_path(::File.join(SERVER_PATH, 'assets', 'javascripts'))
              sprockets.append_path(::File.join(SERVER_PATH, 'assets', 'images'))

              sprockets.context_class.send :extend, Helpers::Asset
            end
          END
        end
      end
    end
  end
end