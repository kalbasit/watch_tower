require 'spec_helper'
require 'rack/test'

module Server
  describe App do
    include Rack::Test::Methods

    def app
      Server::App
    end

    before(:each) do
      @projects = {
        empty: {files: [], time_entries:[] },
        not_empty: {files: [], time_entries: []}
      }

      @projects[:not_empty][:project] = FactoryGirl.create(:project)
      Timecop.freeze(Time.now)
      2.times do
        2.times do
          @projects[:not_empty][:files] << FactoryGirl.create(:file, project: @projects[:not_empty][:project])
        end
        5.times do
          @projects[:not_empty][:time_entries] << FactoryGirl.create(:time_entry, file: @projects[:not_empty][:files].first)
        end
        @projects[:not_empty][:durations] = @projects[:not_empty][:project].durations
        Timecop.freeze(Time.now + 2.days)
      end
      Timecop.return

      @projects[:empty][:project] = FactoryGirl.create(:project)
      2.times do
        @projects[:empty][:files] << FactoryGirl.create(:file, project: @projects[:empty][:project])
      end
      @projects[:empty][:time_entries] << FactoryGirl.create(:time_entry, file: @projects[:empty][:files].first)
      @projects[:empty][:durations] = @projects[:empty][:project].durations
    end

    after(:each) do
      # Reset the from/to date
      visit "/?from_date=&to_date="
    end

    describe "#layout" do
      it "should show a datepicker" do
        visit '/'
        within '#main' do
          page.should have_selector 'aside#date'
          page.should have_selector 'aside#date input'
        end
      end
    end

    describe "#index" do
      before(:each) do
        visit '/'
      end

      it "should render the layout" do
        page.should have_selector :xpath, '//html/head/title'
      end

      it "should have the correct title" do
        within :xpath, '//html/head/title' do
          page.should have_content "Watch Tower - Projects"
        end
      end

      it "should have a projects section" do
        within :xpath, '//html/body' do
          page.should have_selector 'section#projects'
        end
      end

      it "should display each project as an article" do
        within 'section#projects' do
          page.should have_selector '.project'
        end
      end

      it "should display have a section for the project's name" do
        within 'section#projects' do
          page.should have_selector '.project > .name'
        end
      end

      it "should display the name of each project" do
        within 'section#projects .project > .name' do
          page.should have_content @projects[:not_empty][:project].name.camelcase
        end
      end

      it "should not show the project with an empty time entries" do
        within 'section#projects' do
          page.should_not have_content @projects[:empty][:project].name.camelcase
        end
      end

      it "should display the elapsed time of each project" do
        within 'section#projects' do
          page.should have_selector '.project > .elapsed'
        end
      end

      it "should display an image under each project's name to categorize percentage" do
        within 'section#projects' do
          page.should have_selector '.project > .percentage_img_container > .percentage > img'
        end
      end

      it "should have link on each project's name" do
        within 'section#projects .project .name' do
          page.should have_selector('a')
        end
      end

      it "should link to the project's page" do
        within 'section#projects .project .name' do
          page.should have_selector('a', href: "/project/#{@projects[:not_empty][:project].id}")
        end
      end

      it "should display No projects available for the selected date range if there are no projects" do
        Project.delete_all
        visit '/'
        page.should have_content "No projects available for the selected date range."
      end

      it "should display No projects available for the selected date range if projects exist but date range is way off" do
        params = ['from_date=10/01/2001', 'to_date=10/10/2001']
        visit "/?#{params.join('&')}"
        page.should have_content "No projects available for the selected date range."
      end

      it "should display the project with elapsed time with the date range" do
        params = [(Time.now + 1.day).strftime('%m/%d/%Y'), (Time.now + 3.days).strftime('%m/%d/%Y')]
        visit "/?#{params.join('&')}"
        page.should have_content '8 seconds'
      end
    end

    describe "#project" do
      before(:each) do
        visit "/project/#{@projects[:not_empty][:project].id}"
      end

      it "should render the layout" do
        page.should have_selector :xpath, '//html/head/title'
      end

      it "should have the correct title" do
        within :xpath, '//html/head/title' do
          page.should have_content "Watch Tower - Project - #{@projects[:not_empty][:project].name.camelcase}"
        end
      end

      it "should have a projects section" do
        within :xpath, '//html/body' do
          page.should have_selector 'article#project'
        end
      end

      it "should have the an h1 for the project's name" do
        within 'article#project' do
          page.should have_selector 'header > h1.project_name'
        end
      end

      it "should have the project's name in an h1" do
        within 'article#project header > h1.project_name' do
          page.should have_content @projects[:not_empty][:project].name.camelcase
        end
      end

      it "should display an approximate time for the project" do
        within 'article#project' do
          page.should have_content '(about 1 minute)'
        end
      end

      it "should have the an h2 for the project's path" do
        within 'article#project' do
          page.should have_selector 'header > h2.project_path'
        end
      end

      it "should have the project's path in an h2" do
        within 'article#project header > h2.project_path' do
          page.should have_content @projects[:not_empty][:project].path
        end
      end

      it "should have a section for the files" do
        within 'article#project' do
          page.should have_selector 'section#files'
        end
      end

      it "should have a span for the file's path" do
        within 'article#project section#files li.file' do
          page.should have_selector 'span.path'
        end
      end

      it "should display the file's path" do
        within 'article#project section#files li.file span.path' do
          page.should have_content ::File.basename(@projects[:not_empty][:files].first.path)
        end
      end

      it "should have a span for the file's elapsed time" do
        within 'article#project section#files li.file' do
          page.should have_selector 'span.elapsed_time'
        end
      end

      it "should display the file's elaped time" do
        within 'article#project section#files li.file span.elapsed_time' do
          page.should have_content @projects[:not_empty][:files].first.elapsed_time.to_s
        end
      end

      it "should not display files having 0 seconds" do
        within 'article#project section#files' do
          page.should_not have_content @projects[:not_empty][:files].last.path
        end
      end

      it "should display No files available for the selected date range if there are no files" do
        @projects[:not_empty][:project].files.delete_all
        visit "/project/#{@projects[:not_empty][:project].id}"
        page.should have_content "No files available for the selected date range."
      end

      it "should display No files available for the selected date range if projects exist but date range is way off" do
        params = ['from_date=10/01/2001', 'to_date=10/10/2001']
        visit "/project/#{@projects[:not_empty][:project].id}?#{params.join('&')}"
        page.should have_content "No files available for the selected date range."
      end
    end

    describe "#rehash" do
      before(:each) do
        get '/rehash'
      end

      it "should send :recalculate_elapsed_time to all projects" do
        Project.all do |p|
          p.expects(:recalculate_elapsed_time).once
        end
      end

      it "should redirect to the root_path" do
        last_response.should be_redirect
        follow_redirect!
        last_request.url.should =~ /.+\//
      end
    end
  end
end
