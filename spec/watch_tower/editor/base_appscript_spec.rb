require 'spec_helper'

module Editor
  describe BaseAppscript do

    subject do
      Class.new do
        include BaseAppscript
      end.new
    end

    before(:each) do
      @editor = mock
      @editor.stubs(:is_running?).returns(true)
      @documents = mock
      @document = mock
      @file_path = '/path/to/file.rb'
      @path = mock
      @path.stubs(:get).returns(@file_path)
      @document.stubs(:path).returns(@path)
      @documents.stubs(:get).returns([@document])
      @editor.stubs(:document).returns(@documents)

      subject.class.any_instance.stubs(:editor).returns(@editor)
    end

    describe "#is_running" do
      it "should return true if the editor is running" do
        @editor.expects(:is_running?).returns(true).once

        subject.is_running?.should be_true
      end

      it "should return false if the editor is running" do
        @editor.expects(:is_running?).returns(false).once

        subject.is_running?.should be_false
      end
    end

    describe "#cuurent_path" do
      it { should respond_to :current_path }

      it "should return the current_path if textmate running" do
        @path.expects(:get).returns(@file_path).once
        @document.expects(:path).returns(@path).once
        @documents.expects(:get).returns([@document]).once

        subject.current_path.should == @file_path
      end

      it "should return nil if textmate ain't running" do
        @editor.stubs(:is_running?).returns(false)

        subject.current_path.should be_nil
      end
    end

    describe "#cuurent_path" do
      it { should respond_to :current_paths }

      it "should return the current_paths if textmate running" do
        @path.expects(:get).returns(@file_path).once
        @document.expects(:path).returns(@path).once
        @documents.expects(:get).returns([@document]).once

        subject.current_paths.should == [@file_path]
      end

      it "should return nil if textmate ain't running" do
        @editor.stubs(:is_running?).returns(false)

        subject.current_paths.should be_nil
      end
    end
  end
end
