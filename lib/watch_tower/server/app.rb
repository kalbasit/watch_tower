# Sinatra
require 'sinatra'

module WatchTower
  module Server
    class App < ::Sinatra::Application
      # Helper
      include Helpers::ImprovedPartials
      include Helpers::Asset
      include Helpers::Presenters

      # Configurations
      include Configurations::Asset

      # Routes
      paths :root => '/'
      paths :project => '/project/:id'

      # The index action
      get :root do
        @title = "Projects"
        @projects = Project.worked_on

        haml :index
      end

      get :project do
        @project = Project.find(params[:id])
        @title = "Project - #{@project.name.camelcase}"

        haml :project
      end
    end
  end
end