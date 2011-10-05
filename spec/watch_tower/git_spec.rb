require 'spec_helper'

module WatchTower
  describe Git do

    describe "#git_folder_path" do
      it "should respond to :git_folder_path" do
        -> { subject.send(:git_folder_path) }.should_not raise_error NoMethodError
      end

      it "should return a path if exists" do
        File.stubs(:exists?).with('/path/to/project/lib/file.rb/.git').returns(false)
        File.stubs(:exists?).with('/path/to/project/lib/.git').returns(false)
        File.stubs(:exists?).with('/path/to/project/.git').returns(true)

        subject.send(:git_folder_path, '/path/to/project/lib/file.rb').should ==
          '/path/to/project/.git'
      end

      it "should return nil if path does not exist" do
        File.stubs(:exists?).with('/path/to/project/lib/file.rb/.git').returns(false)
        File.stubs(:exists?).with('/path/to/project/lib/.git').returns(false)
        File.stubs(:exists?).with('/path/to/project/.git').returns(false)
        File.stubs(:exists?).with('/path/to/.git').returns(false)
        File.stubs(:exists?).with('/path/.git').returns(false)
        File.stubs(:exists?).with('/.git').returns(false)

        subject.send(:git_folder_path, '/path/to/project/lib/file.rb').should be_nil
      end
    end


    describe "#active_for_path?" do
      it { should respond_to(:active_for_path?) }

      it "should be able to determine if a path is git-ized" do
        Git.expects(:git_folder_path).returns('/path/to/project')

        subject.active_for_path?('/path/to/project/lib/file.rb').should be_true
      end

      it "should be able to determine if a path is not git-ized" do
        Git.expects(:git_folder_path).returns(nil)

        subject.active_for_path?('/path/to/project/lib/file.rb').should be_false
      end
    end

    describe "#working_directory" do
      it { should respond_to(:working_directory) }

      it "should return the working directory of a path" do
        Git.expects(:active_for_path?).returns(true).once
        Git.expects(:git_folder_path).returns('/path/to/project/.git').once

        subject.working_directory('/path/to/project/lib/file.rb').should ==
          '/path/to/project'
      end

      it "should return nil if none found" do
        Git.expects(:active_for_path?).returns(false).once

        subject.working_directory('/path/to/project/lib/file.rb').should be_nil
      end
    end

    describe "#head" do
      before(:each) do
        ::WatchTower::Git.stubs(:active_for_path?).returns(true)
        ::WatchTower::Git.stubs(:working_directory).returns('/path/to/project')
      end

      it { should respond_to :head }

      it "should create a Git::Base object" do
        commit = mock
        git_base = mock
        git_base.stubs(:log).returns([commit])
        ::Git.expects(:open).with('/path/to/project').returns(git_base).once

        subject.head('/path/to/project')
      end

      it "should return the head revision" do
        commit = mock
        git_base = mock
        git_base.stubs(:log).returns([commit])
        ::Git.stubs(:open).with('/path/to/project').returns(git_base)

        subject.head('/path/to/project').should == commit
      end
    end
  end
end