require 'spec_helper'

describe CLI do
  describe "Install" do
    before(:all) do
      @valid_initialize_options = []
    end

    subject { CLI::Runner.new(@valid_initialize_options) }

    it { should respond_to :install }

    it "should copy the config file"
    it "should copy the bootloader"
  end
end