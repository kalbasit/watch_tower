require 'spec_helper'

describe Project do
  describe "Class Methods" do
    subject { Project }

    describe "#new_from_path" do
      it { should respond_to :new_from_path }

      it "should create a project based off of git" do
        ::WatchTower::Git.expects(:active_for_path?).returns(true).once
        ::WatchTower::Git.expects(:base_path_for_path).returns('/path/to/project').once

        p = subject.new_from_path('/path/to/project/lib/file.rb')
        p.should be_instance_of Project
      end

      it "should return the name of the project" do
        ::WatchTower::Git.expects(:active_for_path?).returns(true).once
        ::WatchTower::Git.expects(:base_path_for_path).returns('/path/to/project').once

        p = subject.new_from_path('/path/to/project/lib/file.rb')
        p.name.should == 'project'
      end

      it "should return the path of the project" do
        ::WatchTower::Git.expects(:active_for_path?).returns(true).once
        ::WatchTower::Git.expects(:base_path_for_path).returns('/path/to/project').once

        p = subject.new_from_path('/path/to/project/lib/file.rb')
        p.path.should == '/path/to/project'
      end

    end
  end

  describe "Instance Methods" do
    subject { Project.new '/path/to/project' }

    it { should respond_to :name }
    it { should respond_to :path }
  end
end
