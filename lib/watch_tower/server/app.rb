# Sinatra
require 'sinatra'

module WatchTower
  module Server
    class App < ::Sinatra::Application
      # Helper
      include Helpers::ImprovedPartials
      include Helpers::Asset

      # Include Decorator
      include Decorator

      # Configurations
      include Configurations::Asset

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