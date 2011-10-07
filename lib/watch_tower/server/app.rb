module WatchTower
  module Server
    class App < ::Sinatra::Application
      # Extensions
      include Extensions::ImprovedPartials

      # Routes
      paths :root => '/'

      # The index action
      get :root do
        haml :index
      end
    end
  end
end