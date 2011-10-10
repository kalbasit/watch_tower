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
          page.should have_selector '.project'
        end
      end

      it "should display the name of each project" do
        within 'section#projects' do
          page.should have_selector '.project > .name'
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
          page.should have_selector('a', href: "/project/#{@project.id}")
        end
      end
    end

    describe "#project" do
      before(:each) do
        visit "/project/#{@project.id}"
      end

      it "should render the layout" do
        page.should have_selector :xpath, '//html/head/title'
      end

      it "should have the correct title" do
        within :xpath, '//html/head/title' do
          page.should have_content "Watch Tower - Project - #{@project.name.capitalize}"
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
          page.should have_content @project.name
        end
      end

      it "should have the an h2 for the project's path" do
        within 'article#project' do
          page.should have_selector 'header > h2.project_path'
        end
      end

      it "should have the project's path in an h2" do
        within 'article#project header > h2.project_path' do
          page.should have_content @project.path
        end
      end

      it "should have a section for the files" do
        within 'article#project' do
          page.should have_selector 'section#files'
        end
      end

      it "should have a div for the file's path" do
        within 'article#project section#files article.file' do
          page.should have_selector 'div.path'
        end
      end

      it "should display the file's path" do
        within 'article#project section#files article.file div.path' do
          page.should have_content @file.path
        end
      end

      it "should have a div for the file's elapsed time" do
        within 'article#project section#files article.file' do
          page.should have_selector 'div.elapsed'
        end
      end

      it "should display the file's elaped time" do
        within 'article#project section#files article.file div.elapsed' do
          page.should have_content @file.elapsed_time.to_s
        end
      end

      it "should display an image under each file's name to categorize percentage" do
        within 'article#project section#files article.file' do
          page.should have_selector '.percentage_img_container > .percentage > img'
        end
      end
    end
  end
end