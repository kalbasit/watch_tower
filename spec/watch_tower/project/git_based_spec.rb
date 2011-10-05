require 'spec_helper'

class Project
  describe GitBased do
    before(:all) do
      # Arguments
      @code = '/home/user/Code'
      @file_path = '/home/user/Code/OpenSource/watch_tower/lib/watch_tower/server/models/time_entries.rb'

      # Expected results
      @project_path = '/home/user/Code/OpenSource/watch_tower'
      @project_git_folder_path = @project_path + '/.git'
      @project_name = 'watch_tower'
    end

    before(:each) do
      # Project.stubs(:expand_path).returns
    end

    describe "#project_git_folder_path" do
      it "should respond to :project_git_folder_path" do
        -> { subject.send(:project_git_folder_path) }.should_not raise_error NoMethodError
      end

      it "should return a path if exists" do
        @file_path.split('/').each_index do |i|
          path = @file_path.split('/')[0..i].join('/') + '/.git'
          if @project_git_folder_path == path
            File.stubs(:exists?).with(path).returns(true)
          else
            File.stubs(:exists?).with(path).returns(false)
          end
        end

        subject.send(:project_git_folder_path, @file_path).should == @project_git_folder_path
      end

      it "should return nil if path does not exist" do
        file_path = @file_path.gsub(%r{#{@code}}, '/some/other/path')
        file_path.split('/').each_index do |i|
          path = file_path.split('/')[0..i].join('/')
          File.stubs(:exists?).with(path + '/.git').returns(false)
        end

        subject.send(:project_git_folder_path, file_path).should be_nil
      end

      it "should cache it" do
        File.expects(:exists?).never

        subject.send(:project_git_folder_path, @file_path).should == @project_git_folder_path
      end
    end


    describe "#active_for_path?" do
      it { should respond_to(:active_for_path?) }

      it "should be able to determine if a path is git-ized" do
        GitBased.expects(:project_git_folder_path).returns(@project_path)

        subject.active_for_path?(@file_path).should be_true
      end

      it "should be able to determine if a path is not git-ized" do
        GitBased.expects(:project_git_folder_path).returns(nil)

        subject.active_for_path?(@file_path).should be_false
      end
    end

    describe "#working_directory" do
      it { should respond_to(:working_directory) }

      it "should return the working directory of a path" do
        GitBased.stubs(:project_git_folder_path).returns(@project_git_folder_path)

        subject.working_directory(@file_path).should == @project_path
      end

      it "should cache it" do
        GitBased.expects(:project_git_folder_path).never

        subject.working_directory(@file_path).should == @project_path
      end
    end

    describe "#project_name" do
      it { should respond_to(:project_name) }

      it "should return the working directory of a path" do
        GitBased.stubs(:project_git_folder_path).returns(@project_git_folder_path)

        subject.project_name(@file_path).should == @project_name
      end

      it "should cache it" do
        GitBased.expects(:project_git_folder_path).never

        subject.project_name(@file_path).should == @project_name
      end
    end

    describe "#head" do
      before(:each) do
        GitBased.stubs(:active_for_path?).returns(true)
        GitBased.stubs(:working_directory).returns(@project_path)
      end

      it { should respond_to :head }

      it "should create a Git::Base object" do
        commit = mock
        git_base = mock
        git_base.stubs(:log).returns([commit])
        ::Git.expects(:open).with(@project_path).returns(git_base).once

        subject.head(@project_path)
      end

      it "should return the head revision" do
        commit = mock
        git_base = mock
        git_base.stubs(:log).returns([commit])
        ::Git.stubs(:open).with(@project_path).returns(git_base)

        subject.head(@project_path).should == commit
      end
    end
  end
end