require 'spec_helper'

describe Path do
  before(:all) do
    @code = '/home/user/Code'
    @file_path = '/home/user/Code/OpenSource/watch_tower/lib/watch_tower/server/models/time_entries.rb'
    @nested_project_layers = 2
    @args = [@code, @file_path, @nested_project_layers]

    @project_name = 'watch_tower'
  end

  describe "#project_name_from_path" do
    it "should respond to #project_name_from_path" do
      -> { subject.send :project_name_from_path, *@args }.should_not raise_error NoMethodError
    end

    it "should be able to return the project name from the path Given the correct path" do
      subject.send(:project_name_from_path, *@args).should == @project_name
    end

    it "should raises PathError if the path is not nested under code" do
      file_path = @file_path.gsub(%r{#{@code}}, '/some/other/path')
      -> { subject.send(:project_name_from_path, @code, file_path, @nested_project_layers) }.should raise_error PathNotUnderCodePath
    end
  end
end
