require 'spec_helper'

module Editor
  describe Textmate do
    it "should respond to :app as class methods" do
      Textmate.should respond_to(:app)
    end

    it "should initialize @@app" do
      Textmate.class_variable_get(:@@app).should be_instance_of ::Appscript::Application
    end

    it { should respond_to :current_path }

    describe "#is_running?" do
      it { should respond_to :is_running? }

      it "should return wether Textmate is running or not" do
        ::Appscript::Application.any_instance.expects(:is_running?).returns(true).once

        subject.is_running?.should be_true
      end

      it "should return the current_path if running" do
        ::Appscript::Application.any_instance.expects(:is_running?).returns(true).once
        documents = mock
        document = mock
        path = mock
        path.expects(:get).returns('/path/to/file.rb')
        document.expects(:path).returns(path).once
        documents.expects(:get).returns([document]).once
        ::Appscript::Application.any_instance.expects(:document).returns(documents).once

        subject.current_path.should == '/path/to/file.rb'
      end

    end
  end
end