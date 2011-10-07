require 'sinatra'

module WatchTower
  module Server
    class App < ::Sinatra::Application
      get '/' do
        haml :index
      end
    end
  end
end