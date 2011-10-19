require 'spec_helper'

describe FileTree do
  before(:each) do
    @base_path = "/project"
    @simple_files = [
      { path: "#{@base_path}/file1.rb", elapsed_time: 3600 },
      { path: "#{@base_path}/file2.rb", elapsed_time: 1800 },
    ]
    @files = @simple_files.dup
    @files << { path: "#{@base_path}/folder/file_under_folder1.rb", elapsed_time: 1800 }
    @files << { path: "#{@base_path}/folder/file_under_folder2.rb", elapsed_time: 900 }

    @simple_files_elapsed_times = {
      @base_path => 5400
    }

    @files_elapsed_times = {
      @base_path => 8100,
      "#{@base_path}/folder" => 2700
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

  describe "#tree" do
    it { should respond_to :tree }

    it "should call remove_base_path_from_paths" do
      subject.expects(:remove_base_path_from_paths).once

      subject.tree
    end

    describe "simple files without folders" do
      subject { FileTree.new(@base_path, @simple_files) }

      it "should return a Hash" do
        subject.tree.should be_instance_of Hash
      end

      it "should return a Hash containing an array identified by files" do
        subject.tree[:files].should be_instance_of Array
      end

      it "should include all the files with their elapsed times" do
        subject.tree[:files].each do |f|
          f.should be_instance_of Hash
          f[:path].should =~ /^file(1|2)\.rb$/
          f[:elapsed_time].to_s.should =~ /^(3600|1800)$/
        end
      end

      it "should return elapsed_time" do
        subject.tree[:elapsed_time].should == @simple_files_elapsed_times[@base_path]
      end
    end
  end
end