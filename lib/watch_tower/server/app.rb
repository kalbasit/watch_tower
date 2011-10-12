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
        if params[:from_date] && params[:to_date]
          @projects = Project.
            date_range(params[:from_date], params[:to_date]).
            worked_on
        else
          @projects = Project.worked_on
        end

        haml :index, layout: (request.xhr? ? false : :layout)
      end

      get :project do
        @project = Project.find(params[:id])
        @title = "Project - #{@project.name.camelcase}"

        haml :project, layout: (request.xhr? ? false : :layout)
      end
    end
  end
end