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

    before(:each) do
      ::File.stubs(:exists?).returns(true)
    end

    describe "#new_from_path" do

      it { should respond_to :new_from_path }

      describe "path based" do
        before(:each) do
          Project::GitBased.expects(:active_for_path?).returns(false).once
          Project::PathBased.expects(:working_directory).returns(@project_path).once
          Project::PathBased.expects(:project_name).returns(@project_name).once
        end

        it "should create a project based off of git" do
          p = subject.new_from_path(@file_path)
          p.should be_instance_of subject
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
          Project::GitBased.expects(:active_for_path?).returns(true).once
          Project::GitBased.expects(:working_directory).returns(@project_path).once
          Project::GitBased.expects(:project_name).returns(@project_name).once
        end

        it "should create a project based off of git" do
          p = subject.new_from_path(@file_path)
          p.should be_instance_of subject
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
