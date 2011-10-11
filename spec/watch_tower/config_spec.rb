require 'spec_helper'

describe WatchTower::Config do

  describe "@@config" do
    it "should have and class_variable @@config" do
      -> { subject.send(:class_variable_get, :@@config) }.should_not raise_error NameError
    end
  end

  describe "#ensure_config_file_exists" do
    it "should respond_to ensure_config_file_exists" do
      -> { subject.send :ensure_config_file_exists }.should_not raise_error NoMethodError
    end

    it "should be able to create the config file from the template if it doesn't exist" do
      config_file = mock
      config_file.expects(:write).once
      File.expects(:exists?).with(WatchTower::Config::CONFIG_FILE).returns(false).once
      File.expects(:open).with(WatchTower::Config::CONFIG_FILE, 'w').yields(config_file).once

      subject.send :ensure_config_file_exists
    end
  end
end
