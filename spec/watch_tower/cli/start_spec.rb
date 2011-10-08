require 'spec_helper'

describe CLI do
  describe "Start" do
    before(:all) do
      @valid_initialize_options = []
    end

    subject { CLI::Runner.new(@valid_initialize_options) }

    it { should respond_to :start }

    it "should allow running in the foreground"
    it "should allow setting the host/port of the sinatra app"
    it "should be able to determine if the bootloader called watchtower or not"
  end
end