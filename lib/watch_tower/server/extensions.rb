require 'sinatra-snap'

module WatchTower
  module Server
    module Extensions
      extend ::ActiveSupport::Autoload

      # Sinatra extensions
      autoload :ImprovedPartials
    end
  end
end