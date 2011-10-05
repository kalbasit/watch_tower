require 'spec_helper'

describe Path do
  before(:all) do
    # Arguments
    @code = '/home/user/Code'
    @file_path = '/home/user/Code/OpenSource/watch_tower/lib/watch_tower/server/models/time_entries.rb'
    @nested_project_layers = 2
    @args = [@code, @file_path, @nested_project_layers]
    @options = {
      code: @code,
      nested_project_layers: @nested_project_layers
    }

    # Expected results
    @project_path = '/home/user/Code/OpenSource/watch_tower'
    @project_name = 'watch_tower'
    @project_path_parts = ['/home/user/Code', 'OpenSource', 'watch_tower']
  end

  describe "#project_path_part" do
    it "should respond to #project_path_part" do
      -> { subject.send :project_path_part, *@args }.should_not raise_error NoMethodError
    end

    it "should be able to return the project name from the path Given the correct path" do
      subject.send(:project_path_part, *@args).should == @project_path_parts
    end

    it "should raises PathNotUnderCodePath if the path is not nested under code" do
      file_path = @file_path.gsub(%r{#{@code}}, '/some/other/path')
      -> { subject.send(:project_path_part, @code, file_path, @nested_project_layers) }.should raise_error PathNotUnderCodePath
    end
  end

  describe "#project_name_from_nested_path" do
    it "should respond to #project_name_from_nested_path" do
      -> { subject.send :project_name_from_nested_path, *@args }.should_not raise_error NoMethodError
    end

    it "should be able to return the project path parts from the path Given the correct path" do
      subject.send(:project_name_from_nested_path, *@args).should == @project_name
    end

    it "should raises PathNotUnderCodePath if the path is not nested under code" do
      file_path = @file_path.gsub(%r{#{@code}}, '/some/other/path')
      -> { subject.send(:project_name_from_nested_path, @code, file_path, @nested_project_layers) }.should raise_error PathNotUnderCodePath
    end
  end

  describe "#project_path_from_nested_path" do
    it "should respond to #project_path_from_nested_path" do
      -> { subject.send :project_path_from_nested_path, *@args }.should_not raise_error NoMethodError
    end

    it "should be able to return the project name from the path Given the correct path" do
      subject.send(:project_path_from_nested_path, *@args).should == @project_path
    end

    it "should raises PathNotUnderCodePath if the path is not nested under code" do
      file_path = @file_path.gsub(%r{#{@code}}, '/some/other/path')
      -> { subject.send(:project_path_from_nested_path, @code, file_path, @nested_project_layers) }.should raise_error PathNotUnderCodePath
    end
  end

  describe "#working_directory" do
    it { should respond_to :working_directory }

    it "should return the project path from nested path of the given path" do
      Path.expects(:project_path_from_nested_path).with(*@args).returns(@project_path).once

      subject.working_directory(@file_path, @options).should == @project_path
    end

    it "should cache the path returned for one path to all pathes" do
      Path.expects(:project_path_from_nested_path).with(*@args).returns(@project_path).never

      subject.working_directory(@file_path, @options).should == @project_path
    end
  end
end
