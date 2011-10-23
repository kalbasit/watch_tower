require 'spec_helper'
require 'watch_tower/appscript'

module ::Appscript
  describe "Module" do
    subject do
      Class.new do
        extend ::Appscript
      end
    end
    describe "#app" do

      it { should respond_to :app }

      it "should return an instance of Application" do
        subject.app.should be_instance_of ::Appscript::Application
      end
    end

    describe "#its" do
      it { should respond_to :its }
    end

    describe "#name" do
      it { should respond_to :name }
    end
  end

  describe "Application" do
    subject { ::Appscript.app('TextMate') }

    [:name, :version, :processes, :unix_id, :by_pid, :is_running?].each do |method|
      it "should respond to #{method}" do
        -> {
          subject.send(method)
        }.should_not raise_error NoMethodError
      end
    end
  end
end
