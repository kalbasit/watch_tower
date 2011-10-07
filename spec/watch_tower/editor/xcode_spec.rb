require 'spec_helper'

module Editor
  describe Xcode do
    it "should respond to :app as class methods" do
      Xcode.should respond_to(:app)
    end

    it { should respond_to :current_path }

    describe "#is_running?" do
      it { should respond_to :is_running? }

      it "should return wether Xcode is running or not" do
        app = mock()
        app.expects(:is_running?).returns(true).once
        Xcode.send(:class_variable_set, :@@app, app)

        subject.is_running?.should be_true
      end

      it "should return the current_path if textmate running" do
        app = mock()
        app.expects(:is_running?).returns(true).once
        documents = mock
        document = mock
        path = mock
        path.expects(:get).returns('/path/to/file.rb')
        document.expects(:path).returns(path).once
        documents.expects(:get).returns([document]).once
        app.expects(:document).returns(documents).once
        Xcode.send(:class_variable_set, :@@app, app)

        subject.current_path.should == '/path/to/file.rb'
      end

      it "should return nil if textmate ain't running" do
        app = mock()
        app.expects(:is_running?).returns(false).once
        Xcode.send(:class_variable_set, :@@app, app)

        subject.current_path.should be_nil
      end

    end
  end
end