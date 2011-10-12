require 'sinatra-snap'

module WatchTower
  module Server
    module Helpers
      extend ::ActiveSupport::Autoload

      # Sinatra helpers
      autoload :ImprovedPartials
      autoload :Asset
      autoload :Presenters
    end
  end
end