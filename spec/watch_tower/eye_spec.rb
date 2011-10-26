require 'spec_helper'

describe Eye do
  before(:each) do
    # We don't want to locked in a loop
    $close_eye = true

    # Set the project's name and path
    @file_path = '/home/user/Code/OpenSource/watch_tower/lib/watch_tower/server/models/time_entries.rb'
    @project_path = '/home/user/Code/OpenSource/watch_tower'
    @project_name = 'watch_tower'
    ::File.stubs(:exists?).with(@file_path).returns(true)
    ::File.stubs(:file?).with(@file_path).returns(true)

    # Mock the editor
    @editor = mock
    @editor.stubs(:new).returns(@editor)
    @editor.stubs(:is_running?).returns(true)
    @editor.stubs(:current_paths).returns([@file_path])
    @editor.stubs(:name).returns("Textmate")
    @editor.stubs(:version).returns("1.5.10")
    Editor.stubs(:editors).returns([@editor])

    # Mock the project
    @project = mock
    @project.stubs(:path).returns(@project_path)
    @project.stubs(:name).returns(@project_name)
    Project.stubs(:new_from_path).returns(@project)

    # Stub the mtime
    @mtime = Time.now
    @file_stat = mock
    @file_stat.stubs(:mtime).returns(@mtime)
    ::File.stubs(:stat).returns(@file_stat)

    # Stub the file_hash
    @file_hash = mock
    @file_hash.stubs(:hexdigest).returns('b1843f2aeea08c34a4a0b978b117256cd4615a6c')
    Digest::SHA1.stubs(:file).with(@file_path).returns(@file_hash)
  end

  describe "#start workflow" do
    before(:each) do
      # Mock the project's model
      # @time_entry = stub_everything('time_entry')
      # @file_model = stub_everything('file', time_entries: [@time_entries])
      # @project_model = stub_everything('project', files: [@file_model])
      # Server::Project.stubs(:find_or_create_by_name_and_path).returns(@project_model)
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

    it "should call File.exists?" do
      ::File.expects(:exists?).with(@file_path).returns(true).once

      subject.start
    end

    it "should call File.file?" do
      ::File.expects(:file?).with(@file_path).returns(true).once

      subject.start
    end

    it "shouldn't add the file if it matches the ignore list" do
      ignored_path = '/path/to/project/.git/COMMIT_MESSAGE'
      ::File.stubs(:exists?).with(ignored_path).returns(true)
      @editor.stubs(:current_paths).returns([ignored_path])
      Digest::SHA1.expects(:file).with(ignored_path).never

      subject.start
    end

    it "should get the file's hash from Digest::SHA1" do
      Digest::SHA1.expects(:file).with(@file_path).returns(@file_hash).once

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

    it "should ask the editor for the name" do
      @editor.expects(:name).returns("Textmate").once

      subject.start
    end

    it "should ask the editor for the version" do
      @editor.expects(:version).returns("1.5.10").once

      subject.start
    end
  end

  describe "#start database validations" do
    it "should create a new (or fetch existing) Project in the database" do
      subject.start

      Server::Project.last.name.should == @project_name
      Server::Project.last.path.should == @project_path
    end

    it "should create a new (or fetch existing) File in the database" do
      subject.start

      Server::File.last.path.should == @file_path
    end

    it "should create a new TimeEntry in the database" # do
     #      subject.start
     #
     #      Server::TimeEntry.last.mtime.should == @mtime
     #    end

    it "should not raise an error if the time entry for the file already exists" do
      subject.start

      -> { subject.start }.should_not raise_error
    end
  end
end
