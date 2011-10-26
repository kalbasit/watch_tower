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
    end
  end
end
