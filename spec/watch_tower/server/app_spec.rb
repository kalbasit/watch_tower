require 'spec_helper'

module Server
  describe App do
    before(:each) do
      @project = FactoryGirl.create :project
      @file = FactoryGirl.create :file, project: @project
      @time_entry = FactoryGirl.create :time_entry, file: @file
      @duration = FactoryGirl.create :duration, file: @file
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
          page.should have_selector '.watch_tower_server_project'
        end
      end

      it "should display the name of each project" do
        within 'section#projects' do
          page.should have_selector '.watch_tower_server_project > .name'
        end
      end

      it "should display the elapsed time of each project" do
        within 'section#projects' do
          page.should have_selector '.watch_tower_server_project > .elapsed'
        end
      end
    end
  end
end