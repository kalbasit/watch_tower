# Sinatra
require 'sinatra'

module WatchTower
  module Server
    class App < ::Sinatra::Application
      # Extensions
      include Extensions::ImprovedPartials

      # Routes
      paths :root => '/'

      # The index action
      get :root do
        @title = "Projects"
        @projects = Project.all

        haml :index
      end
    end
  end
end