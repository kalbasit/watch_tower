require 'spec_helper'

module WatchTower
  describe Git do

    describe "#git_folder_path" do
      it "should respond to :git_folder_path" do
        -> { subject.send(:git_folder_path) }.should_not raise_error NoMethodError
      end

      it "should return a path if exists"
      it "should return nil if path does not exist"
    end


    describe "#active_for_path?" do
      it { should respond_to(:active_for_path?) }

      it "should be able to determine if a path is git-ized" do
        subject.active_for_path?(File.dirname(__FILE__)).should be_true
      end
    end

    describe "#base_path_for_path" do
      it { should respond_to(:base_path_for_path) }
    end

    describe "#head" do
      before(:each) do
        ::WatchTower::Git.stubs(:active_for_path?).returns(true)
        ::WatchTower::Git.stubs(:base_path_for_path).returns('/path/to/project')
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