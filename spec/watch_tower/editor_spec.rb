require 'spec_helper'

describe Editor do
  describe "#editors" do
    it { should respond_to :editors}

    it "should return an array of editors" do
      subject.editors.should be_instance_of Array
    end

    it "should return Textmate" do
      subject.editors.should include Editor::Textmate
    end

    it "should return Xcode" do
      subject.editors.should include Editor::Xcode
    end
  end
end
