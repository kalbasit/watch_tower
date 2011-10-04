require 'spec_helper'

describe CLI do
  describe "Thor" do
    before(:all) do
      @valid_initialize_options = []
    end

    subject { CLI::Runner.new(@valid_initialize_options) }

    describe "Thor group definition" do
      subject { CLI::Runner }
      it { should respond_to(:desc) }
      it { should respond_to(:class_option) }
      it { should respond_to(:argument) }
      its (:desc) { should_not be_empty }
    end

    describe "foreground" do
      it "should have a class_option input_format defined" do
        CLI::Runner.class_options.should have_key(:foreground)
      end

      it "should not be required" do
        -> { CLI::Runner.new @valid_initialize_options }.should_not
          raise_error Thor::RequiredArgumentMissingError
      end

      it "should set options[:foreground] to true" do
        cli = CLI::Runner.new @valid_initialize_options, foreground: true
        cli.options[:foreground].should be_true
      end

      it "should set options[:foreground] to false" do
        cli = CLI::Runner.new @valid_initialize_options, foreground: false
        cli.options[:foreground].should be_false
      end
    end

  end
end