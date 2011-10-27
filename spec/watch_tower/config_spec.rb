require 'spec_helper'

describe WatchTower::Config do

  describe "@@config" do
    before(:each) do
      WatchTower::Config.stubs(:ensure_config_file_exists)
      WatchTower::Config.send(:class_variable_set, :@@config, nil)
    end

    it "should have and class_variable @@config" do
      -> { subject.send(:class_variable_get, :@@config) }.should_not raise_error NameError
    end

    it "should check if the config file exists" do
      ::File.expects(:exists?).with(WatchTower::Config.config_file).once

      subject[:enabled]
    end

    it "should call config_file" do
      WatchTower::Config.expects(:config_file).once

      subject[:enabled]
    end

    it "should not raise an exception if the config is not found" do
      WatchTower::Config.stubs(:config_file).returns('/invalid/path')
      -> { subject[:enabled] }.should_not raise_error
    end
  end

  describe "#ensure_config_file_exists" do
    it "should respond_to ensure_config_file_exists" do
      -> { subject.send :ensure_config_file_exists }.should_not raise_error NoMethodError
    end

    it "should be able to create the config file from the template if it doesn't exist" do
      config_file = mock
      config_file.expects(:write).once
      File.expects(:exists?).with(WatchTower::Config.config_file).returns(false).once
      File.expects(:open).with(WatchTower::Config.config_file, 'w').yields(config_file).once

      subject.send :ensure_config_file_exists
    end
  end
end
