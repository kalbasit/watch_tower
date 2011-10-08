require 'spec_helper'

describe CLI do
  describe "Start" do
    before(:all) do
      @valid_initialize_options = []
    end

    subject { CLI::Runner.new(@valid_initialize_options) }
  end
end