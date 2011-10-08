# Sinatra
require 'sinatra'

module WatchTower
  module Server
    class App < ::Sinatra::Application
      # Extensions
      include Extensions::ImprovedPartials

      # Include Decorator
      include Decorator

      # Routes
      paths :root => '/'

      # The index action
      get :root do
        @title = "Projects"
        @projects = ProjectDecorator.decorate(Project.all)

        haml :index
      end
    end
  end
end