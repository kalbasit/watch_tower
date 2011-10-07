require 'spec_helper'

describe Eye do
  before(:each) do
    # We don't want to locked in a loop
    $close_eye = true
  end
  describe "#start" do
    before(:each) do
      # Set the project's name and path
      @file_path = '/home/user/Code/OpenSource/watch_tower/lib/watch_tower/server/models/time_entries.rb'
      @project_path = '/home/user/Code/OpenSource/watch_tower'
      @project_name = 'watch_tower'

      # Mock the editor
      @editor = mock
      @editor.stubs(:is_running?).returns(true)
      @editor.stubs(:current_paths).returns([@file_path])
      Editor.stubs(:editors).returns([@editor])

      # Mock the project
      @project = mock
      @project.stubs(:path).returns(@project_path)
      @project.stubs(:name).returns(@project_name)
      Project.stubs(:new_from_path).returns(@project)

      # Mock the project's model
      # @time_entry = stub_everything('time_entry')
      # @file_model = stub_everything('file', time_entries: [@time_entries])
      # @project_model = stub_everything('project', files: [@file_model])
      # Server::Project.stubs(:find_or_create_by_name_and_path).returns(@project_model)

      # Stub the mtime
      @file_stat = mock
      @file_stat.stubs(:mtime).returns(Time.now)
      ::File.stubs(:stat).returns(@file_stat)
    end

    it { should respond_to :start }

    it "should tries to get the editors list" do
      Editor.expects(:editors).returns([]).once

      subject.start
    end

    it "should call is_running? on the editor" do
      @editor.expects(:is_running?).returns(false).once
      Editor.stubs(:editors).returns([@editor])

      subject.start
    end

    it "should call current_paths on the editor to determine the file path" do
      @editor.expects(:current_paths).returns([@file_path]).once

      subject.start
    end

    it "should create a new project from the file path" do
      Project.expects(:new_from_path).returns(@project).once

      subject.start
    end

    it "should ask the project for the project's name" do
      @project.expects(:name).returns(@project_name).once

      subject.start
    end

    it "should ask the project for the project's path" do
      @project.expects(:path).returns(@project_path).once

      subject.start
    end

    it "should create a new (or fetch existing) Project in the database"
    it "should create a new (or fetch existing) File in the database"
    it "should create a new TimeEntry in the database"

    it "should ask the file for mtime" do
      @file_stat.expects(:mtime).returns(Time.now).once
      ::File.expects(:stat).with(@file_path).returns(@file_stat)

      subject.start
    end
  end
end
