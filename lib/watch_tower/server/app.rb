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

      # Before filter
      before do
        # Parse the from/to date from params and add it to the session
        if params[:from_date] && params[:to_date]
          if params[:from_date].present? && params[:to_date].present?
            session[:date_filtering] = {
              from_date: params[:from_date],
              to_date: params[:to_date]
            }
          else
            session[:date_filtering] = nil
          end
        end

        # Make sure we have a default date filtering
        unless session.try(:[], :date_filtering).try(:[], :from_date) && session.try(:[], :date_filtering).try(:[], :to_date)
          session[:date_filtering] = {
            from_date: Time.now.to_date.beginning_of_month.strftime('%m/%d/%Y'),
            to_date: Time.now.to_date.strftime('%m/%d/%Y')
          }
        end
      end

      # The index action
      get :root do
        @title = "Projects"
        @projects = Project.
          date_range(session[:date_filtering][:from_date], session[:date_filtering][:to_date]).
          worked_on

        haml :index, layout: (request.xhr? ? false : :layout)
      end

      get :project do
        @project = Project.find(params[:id])
        @title = "Project - #{@project.name.camelcase}"
        @files = @project.files.
          date_range(session[:date_filtering][:from_date], session[:date_filtering][:to_date]).
          worked_on

        haml :project, layout: (request.xhr? ? false : :layout)
      end
    end
  end
end