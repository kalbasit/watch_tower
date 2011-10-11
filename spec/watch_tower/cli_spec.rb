require 'spec_helper'

describe CLI do
  before(:all) do
    @valid_initialize_options = []
  end

  subject { CLI::Runner.new(@valid_initialize_options) }

  describe "Thor definition" do
    subject { CLI::Runner }
    it { should respond_to(:desc) }
    it { should respond_to(:method_option) }
  end
end