require 'spec_helper'

module Editor
  describe Textmate do
    before(:each) do
      @file_path = '/path/to/file.rb'
      @app = mock()
      @app.stubs(:is_running?).returns(true)
      @documents = mock
      @document = mock
      @path = mock
      @path.stubs(:get).returns(@file_path)
      @document.stubs(:path).returns(@path)
      @documents.stubs(:get).returns([@document])
      @app.stubs(:document).returns(@documents)
      @name = mock
      @name.stubs(:get).returns("TextMate")
      @app.stubs(:name).returns(@name)
      @version = mock
      @version.stubs(:get).returns("1.5.10")
      @app.stubs(:version).returns(@version)
      Textmate.any_instance.stubs(:editor).returns(@app)
    end

    it { should respond_to :current_path }

    it { should respond_to :name }
    its(:name) { should_not raise_error NotImplementedError }
    its(:name) { should_not be_empty }

    it { should respond_to :version }
    its(:version) { should_not raise_error NotImplementedError }
    its(:version) { should_not be_empty }

    describe "#is_running?" do
      it { should respond_to :is_running? }

      it "should return wether Textmate is running or not" do
        @app.expects(:is_running?).returns(true).once

        subject.is_running?.should be_true
      end
    end

    describe "#cuurent_path" do
      it { should respond_to :current_path }

      it "should return the current_path if textmate running" do
        @app.expects(:is_running?).returns(true).once
        @path.expects(:get).returns(@file_path).once
        @document.expects(:path).returns(@path).once
        @documents.expects(:get).returns([@document]).once
        @app.expects(:document).returns(@documents).once
        Textmate.any_instance.stubs(:editor).returns(@app)

        subject.current_path.should == @file_path
      end

      it "should return nil if textmate ain't running" do
        @app.expects(:is_running?).returns(false).once
        Textmate.any_instance.stubs(:editor).returns(@app)

        subject.current_path.should be_nil
      end
    end

    describe "#cuurent_path" do
      it { should respond_to :current_paths }

      it "should return the current_paths if textmate running" do
        @app.expects(:is_running?).returns(true).once
        @path.expects(:get).returns(@file_path).once
        @document.expects(:path).returns(@path).once
        @documents.expects(:get).returns([@document]).once
        @app.expects(:document).returns(@documents).once
        Textmate.any_instance.stubs(:editor).returns(@app)

        subject.current_paths.should == [@file_path]
      end

      it "should return nil if textmate ain't running" do
        @app.expects(:is_running?).returns(false).once
        Textmate.any_instance.stubs(:editor).returns(@app)

        subject.current_paths.should be_nil
      end
    end

  end
end
