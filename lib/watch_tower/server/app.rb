# -*- encoding: utf-8 -*-

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
      paths :rehash => '/rehash'
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
        @durations = Duration.date_range(session[:date_filtering][:from_date], session[:date_filtering][:to_date])
        @projects = @durations.collect(&:file).collect(&:project).uniq

        haml :index, layout: (request.xhr? ? false : :layout)
      end

      # The project action
      get :project do
        @project = Project.find(params[:id])
        @title = "Project - #{@project.name.camelcase}"
        @durations = @project.durations.date_range(session[:date_filtering][:from_date], session[:date_filtering][:to_date])
        @files = @durations.collect(&:file).uniq

        haml :project, layout: (request.xhr? ? false : :layout)
      end

      # Rehash the elapsed_times
      get :rehash do
        # Pause the eye to avoid conflicts
        $pause_eye = true
        # Iterate over all projects and recalculate_elapsed_time
        Project.all.each do |p|
          p.recalculate_elapsed_time
        end
        # Resume the eye
        $pause_eye = false
        # Redirect back to the home page.
        redirect path_to(:root)
      end
    end
  end
end
