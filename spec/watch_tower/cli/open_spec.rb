require 'spec_helper'

describe CLI do
  describe "Open" do
    before(:all) do
      @valid_initialize_options = []
    end

    subject { CLI::Runner.new(@valid_initialize_options) }

    it { should respond_to :open }

  end
end