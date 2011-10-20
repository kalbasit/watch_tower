require 'spec_helper'

module Server
  module Presenters
    describe ProjectPresenter do

      describe "elapsed formatter" do
        before(:each) do
          @project = FactoryGirl.create :project
        end

        subject { ProjectPresenter.new(@project, nil) }

        it "should return a formatted elapsed time" do
          time = 1.day + 2.hours + 3.minutes + 34.seconds
          model = mock
          model.stubs(:elapsed_time).returns(time)
          subject.stubs(:model).returns(model)
          subject.elapsed.should == '1 day, 2 hours, 3 minutes and 34 seconds'
        end
      end

      describe "File tree" do
        before(:each) do
          @project = FactoryGirl.create :project
          @project_path = @project.path
          @file_paths = [
            "#{@project_path}/file1.rb",
            "#{@project_path}/file2.rb",
            "#{@project_path}/folder/file_under_folder1.rb",
            "#{@project_path}/folder/file_under_folder2.rb",
          ]
          @file_paths.each do |fp|
            f = FactoryGirl.create :file, project: @project, path: fp
            2.times do
              Timecop.freeze(Time.now + 1)
              FactoryGirl.create :time_entry, file: f, mtime: Time.now
            end
          end

          @files = @project.reload.files
          @tree = FileTree.new(@project_path, @project.reload.files)
          @elapsed_time = @project.elapsed_time
        end

        subject { ProjectPresenter.new(@project, nil) }

        describe "#parse_file_tree" do
          it { should respond_to :parse_file_tree }

          it "should return a div with id root" do
            subject.send(:parse_file_tree, @tree, true).should =~ %r(^<div id="root" class="folder"[^>]*>.*</div>$)
          end

          it "should return a div with id nested_folder" do
            subject.send(:parse_file_tree, @tree.nested_tree['folder']).should =~ %r(^<div id="nested_folder" class="nested_folder"[^>]*>.*</div>$)
          end

          it "should return a span for the name, files for the root" do
            subject.send(:parse_file_tree, @tree, true).should =~
              %r(^<div id="root"[^>]*>.*<span class="name">\s*files\s*</span>.*</div>$)
          end

          it "should return a span for the name, folder for the nested folder" do
            subject.send(:parse_file_tree, @tree.nested_tree['folder']).should =~
              %r(^<div id="nested_folder"[^>]*>.*<span class="name">\s*folder\s*</span>.*</div>$)
          end

          it "should return a span for the elapsed time (root)" do
            subject.send(:parse_file_tree, @tree, true).should =~
              %r(^<div id="root"[^>]*>.*<span class="elapsed_time">\s*#{subject.elapsed(@elapsed_time)}\s*</span>.*</div>$)
          end

          it "should return a span for the elapsed time (folder)" do
            subject.send(:parse_file_tree, @tree.nested_tree['folder']).should =~
              %r(^<div id="nested_folder"[^>]*>.*<span class="elapsed_time">\s*#{subject.elapsed(@elapsed_time / 2)}\s*</span>.*</div>$)
          end

          it "should return the folder tree inside the tree" do
            subject.send(:parse_file_tree, @tree, true).should =~
              %r(^<div id="root"[^>]*>.*<div id="nested_folder"[^>]*>.*</div>)
          end

          it "should return the files" do
            subject.send(:parse_file_tree, @tree, true).should =~
              %r(^<div id="root"[^>]*>.*<ul class="files"[^>]*>.*</ul>.*</div>)
          end

          it "should return the path of the files" do
            subject.send(:parse_file_tree, @tree, true).should =~
              %r(^<div id="root"[^>]*>.*<ul class="files"[^>]*>.*<li class="file">.*<span class="path">file1.rb</span>.*</li>.*</ul>.*</div>)
          end

          it "should return the elapsed time of the files" do
            subject.send(:parse_file_tree, @tree, true).should =~
              %r(^<div id="root"[^>]*>.*<ul class="files"[^>]*>.*<li class="file">.*<span class="elapsed_time">1 second</span>.*</li>.*</ul>.*</div>)
          end
        end

        describe "#file_tree" do
          it { should respond_to :file_tree }

          it "should return a div with id root" do
            regex = %r(.*root.*name.*elapsed_time.*nested_folder.*files.*file_under_folder(1|2).*files.*file(1|2).*)

            subject.file_tree(@files).should =~ regex
          end
        end
      end
    end
  end
end