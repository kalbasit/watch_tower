require 'spec_helper'

describe FileTree do
  before(:each) do
    @base_path = "/project"
    @files = [
      { path: "#{@base_path}/file1.rb", elapsed_time: 3600 },
      { path: "#{@base_path}/file2.rb", elapsed_time: 1800 },
      { path: "#{@base_path}/folder/file1.rb", elapsed_time: 1800 },
      { path: "#{@base_path}/folder/file2.rb", elapsed_time: 1800 },
    ]

    @elapsed_times = {
      @base_path => 9000,
      "#{@base_path}/folder" => 3600
    }
  end

  subject { FileTree.new(@base_path, @files) }

  describe "#remove_base_path_from_paths" do
    it { should respond_to :remove_base_path_from_paths }

    it "should remove the base_path from all the files in the @files array" do
      subject.send :remove_base_path_from_paths

      subject.files.each do |f|
        f[:path].should_not match %r(#{@base_path}/)
      end
    end
  end
end