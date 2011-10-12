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

      # Enable sessions
      enable :sessions

      # The index action
      get :root do
        @title = "Projects"
        # Parse the from/to date from params and add it to the session
        if params[:from_date] && params[:to_date]
          session[:date_filtering] = {
            from_date: params[:from_date],
            to_date: params[:to_date]
          }
        end
        # Either use date filtering or not
        if session.try(:[], :date_filtering).try(:[], :from_date) && session.try(:[], :date_filtering).try(:[], :to_date)
          @projects = Project.
            date_range(session[:date_filtering][:from_date], session[:date_filtering][:to_date]).
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