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

  describe "#remove_base_path_from_files" do
    subject { FileTree.new(@base_path, @files) }

    it { should respond_to :remove_base_path_from_files }

    it "should remove the base_path from all the files in the @files array" do
      files = subject.send(:remove_base_path_from_files, @base_path, @simple_files)

      files.each do |f|
        f[:path].should_not match %r(#{@base_path}/)
      end
    end
  end

  describe "#process" do
    subject { FileTree.new(@base_path, @files) }

    it { should respond_to :process }

    it "should be called on initialize" do
      FileTree.any_instance.expects(:process).once

      FileTree.new(@base_path, @files)
    end

    it "should call parse_files" do
      FileTree.any_instance.expects(:parse_files).once
      FileTree.any_instance.stubs(:parse_folders)

      FileTree.new(@base_path, @files)
    end

    it "should call parse_folders" do
      FileTree.any_instance.stubs(:parse_files)
      FileTree.any_instance.expects(:parse_folders).once

      FileTree.new(@base_path, @files)
    end
  end

  describe "simple files without folders" do
    subject { FileTree.new(@base_path, @simple_files) }

    describe "#files" do
      it { should respond_to :files }

      it "should return an array" do
        subject.files.should be_instance_of Array
      end

      it "should include all the files with their elapsed times" do
        subject.files.each do |f|
          f.should be_instance_of Hash
          f[:path].should =~ /^file(1|2)\.rb$/
          f[:elapsed_time].to_s.should =~ /^(3600|1800)$/
        end
      end
    end

    describe "#elapsed_time" do
      it { should respond_to :elapsed_time }

      it "should return elapsed_time" do
        subject.elapsed_time.should == @simple_files_elapsed_times[@base_path]
      end
    end

    describe "#nested_tree" do
      it { should respond_to :nested_tree }

      it "should have an empty nested_tree" do
        subject.nested_tree.should be_empty
      end

    end
  end

  describe "files with folders" do
    subject { FileTree.new(@base_path, @files) }

    describe "#files" do
      it { should respond_to :files }

      it "should return an array" do
        subject.files.should be_instance_of Array
      end

      it "should include all the files with their elapsed times" do
        subject.files.each do |f|
          f.should be_instance_of Hash
          f[:path].should =~ /^file(1|2)\.rb$/
          f[:elapsed_time].to_s.should =~ /^(3600|1800)$/
        end
      end
    end

    describe "#elapsed_time" do
      it { should respond_to :elapsed_time }

      it "should return elapsed_time" do
        subject.elapsed_time.should == @files_elapsed_times[@base_path]
      end
    end

    describe "#nested_tree" do
      it { should respond_to :nested_tree }

      it "should not have an empty nested_tree" do
        subject.nested_tree.should_not be_empty
      end

      it "should be a Hash" do
        subject.nested_tree.should be_instance_of Hash
      end

      it "should return a FileTree for each element of the hash" do
        subject.nested_tree['folder'].should be_instance_of FileTree
      end

      it "should include all the files under the folder" do
        subject.nested_tree['folder'].files.each do |f|
          f.should be_instance_of Hash
          f[:path].should =~ /^file_under_folder(1|2)\.rb$/
          f[:elapsed_time].to_s.should =~ /^(1800|900)$/
        end
      end

      it "should return the elapsed time of the folder" do
        subject.nested_tree['folder'].elapsed_time.should == @files_elapsed_times["#{@base_path}/folder"]
      end
    end
  end
end