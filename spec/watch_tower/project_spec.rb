require 'spec_helper'

describe Project do
  describe "Class Methods" do
    subject { Project }

    before(:all) do
      # Arguments
      @code = '/home/user/Code'
      @file_path = '/home/user/Code/OpenSource/watch_tower/lib/watch_tower/server/models/time_entries.rb'

      # Expected results
      @project_path = '/home/user/Code/OpenSource/watch_tower'
      @project_name = 'watch_tower'
    end

    describe "#new_from_path" do

      it { should respond_to :new_from_path }

      describe "path based" do
        before(:each) do
          ::WatchTower::Git.expects(:active_for_path?).returns(false).once
          ::WatchTower::Path.expects(:working_directory).returns(@project_path).once
          ::WatchTower::Path.expects(:project_name).returns(@project_name).once
        end

        it "should create a project based off of git" do
          p = subject.new_from_path(@file_path)
          p.should be_instance_of Project
        end

        it "should return the name of the project" do
          p = subject.new_from_path(@file_path)
          p.name.should == @project_name
        end

        it "should return the path of the project" do
          p = subject.new_from_path(@file_path)
          p.path.should == @project_path
        end
      end

      describe "git based" do
        before(:each) do
          ::WatchTower::Git.expects(:active_for_path?).returns(true).once
          ::WatchTower::Git.expects(:working_directory).returns(@project_path).once
          ::WatchTower::Git.expects(:project_name).returns(@project_name).once
        end

        it "should create a project based off of git" do
          p = subject.new_from_path(@file_path)
          p.should be_instance_of Project
        end

        it "should return the name of the project" do
          p = subject.new_from_path(@file_path)
          p.name.should == @project_name
        end

        it "should return the path of the project" do
          p = subject.new_from_path(@file_path)
          p.path.should == @project_path
        end
      end
    end
  end

  describe "Instance Methods" do
    subject { Project.new @project_name, @project_path }

    it { should respond_to :name }
    it { should respond_to :path }

    its(:name) { should == @project_name }
    its(:path) { should == @project_path }
  end
end
