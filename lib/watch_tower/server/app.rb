require 'sinatra'
require 'sinatra-snap'

module WatchTower
  module Server
    class App < ::Sinatra::Application
      # Define routes
      paths :root => '/'

      # The index action
      get :root do
        haml :index
      end
    end
  end
end