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
      paths :project => '/project/:id'

      # The index action
      get :root do
        @title = "Projects"
        @projects = ProjectDecorator.decorate(Project.all)

        haml :index
      end

      get :project do
        @project = ProjectDecorator.find(params[:id])
        @title = "Project - #{@project.name.capitalize}"

        haml :project
      end
    end
  end
end