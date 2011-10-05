require 'spec_helper'

module WatchTower
  describe Git do
    before(:all) do
      # Arguments
      @file_path = '/home/user/Code/OpenSource/watch_tower/lib/watch_tower/server/models/time_entries.rb'

      # Expected results
      @project_path = '/home/user/Code/OpenSource/watch_tower'
      @git_folder_path = @project_path + '/.git'
      @project_name = 'watch_tower'
    end

    describe "#git_folder_path" do
      it "should respond to :git_folder_path" do
        -> { subject.send(:git_folder_path) }.should_not raise_error NoMethodError
      end

      it "should return a path if exists" do
        @file_path.split('/').each_index do |i|
          path = @file_path.split('/')[0..i].join('/') + '/.git'
          if @git_folder_path == path
            File.stubs(:exists?).with(path).returns(true)
          else
            File.stubs(:exists?).with(path).returns(false)
          end
        end

        subject.send(:git_folder_path, @file_path).should == @git_folder_path
      end

      it "should return nil if path does not exist" do
        @file_path.split('/').each_index do |i|
          path = @file_path.split('/')[0..i].join('/')
          File.stubs(:exists?).with(path + '/.git').returns(false)
        end

        subject.send(:git_folder_path, @file_path).should be_nil
      end
    end


    describe "#active_for_path?" do
      it { should respond_to(:active_for_path?) }

      it "should be able to determine if a path is git-ized" do
        Git.expects(:git_folder_path).returns(@project_path)

        subject.active_for_path?(@file_path).should be_true
      end

      it "should be able to determine if a path is not git-ized" do
        Git.expects(:git_folder_path).returns(nil)

        subject.active_for_path?(@file_path).should be_false
      end
    end

    describe "#working_directory" do
      it { should respond_to(:working_directory) }

      it "should return the working directory of a path" do
        Git.expects(:git_folder_path).returns(@git_folder_path).once

        subject.working_directory(@file_path).should ==
          @project_path
      end
    end

    describe "#project_name" do
      it { should respond_to(:project_name) }

      it "should return the working directory of a path" do
        Git.expects(:git_folder_path).returns(@git_folder_path).once

        subject.project_name(@file_path).should == @project_name
      end
    end

    describe "#head" do
      before(:each) do
        ::WatchTower::Git.stubs(:active_for_path?).returns(true)
        ::WatchTower::Git.stubs(:working_directory).returns(@project_path)
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