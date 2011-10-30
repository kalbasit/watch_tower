require 'spec_helper'

describe WatchTower::Config do
  before(:each) do
    @config = {watch_tower: {enabled: true}}
    @config_path = '/valid/path'
    @invalid_config_path = '/invalid/path'
    @yaml = mock
    @yaml.stubs(:to_ruby).returns(@config)
    Psych.stubs(:parse_file).with(@config_path).returns(@yaml)
    WatchTower::Config.stubs(:config_file).returns(@config_path)

    ::File.stubs(:exists?).with(@config_path).returns(true)
    ::File.stubs(:readable?).with(@config_path).returns(true)

    ::File.stubs(:exists?).with(@invalid_config_path).returns(false)
    ::File.stubs(:readable?).with(@invalid_config_path).returns(false)
  end

  describe "@@config" do
    it "should have and class_variable @@config" do
      -> { subject.send(:class_variable_get, :@@config) }.should_not raise_error NameError
    end
  end

  describe "#check_config_file" do
    before(:each) do
      WatchTower::Config.stubs(:initialize_config_file)
    end

    it { should respond_to :check_config_file }

    it "should call File.exists?" do
      ::File.expects(:exists?).with(@config_path).returns(true).once

      subject.send(:check_config_file)
    end

    it "should call File.readable?" do
      ::File.expects(:readable?).with(@config_path).returns(true).once

      subject.send(:check_config_file)
    end
  end

  describe "#initialize_config_file" do
    it { should respond_to :initialize_config_file }

    it "should be able to create the config file from the template" do
      config_file = mock
      config_file.expects(:write).once
      File.expects(:open).with(WatchTower::Config.config_file, 'w').yields(config_file).once

      subject.send :initialize_config_file
    end
  end

  describe "#parse_config_file" do
    before(:each) do
      WatchTower::Config.send(:class_variable_set, :@@config, nil)
      WatchTower::Config.stubs(:initialize_config_file)
    end

    it { should respond_to :parse_config_file }

    it "should parse the config file and return an instance of HashWithIndifferentAccess" do
      subject.send(:parse_config_file).should be_instance_of HashWithIndifferentAccess
    end

    it "should handle the case where config is not a valid YAML file." do
      Psych.stubs(:parse_file).raises(Psych::SyntaxError)

      -> { subject.send :parse_config_file }.should raise_error ConfigNotValidError
    end

    it "should handle the case where Psych returns nil." do
      Psych.stubs(:parse_file).with(@config_path).returns(nil)

      -> { subject.send :parse_config_file }.should raise_error ConfigNotValidError
    end

    it "should handle the case where :watch_tower key does not exist" do
      config = {}
      yaml = mock
      yaml.stubs(:to_ruby).returns(config)
      Psych.stubs(:parse_file).with(@config_path).returns(yaml)

      -> { subject.send :parse_config_file }.should raise_error ConfigNotValidError
    end
  end

  describe "#[]" do
    before(:each) do
      WatchTower::Config.send(:class_variable_set, :@@config, nil)
      WatchTower::Config.stubs(:initialize_config_file)
    end

    it "should call check_config_file" do
      WatchTower::Config.expects(:check_config_file).once

      subject[:enabled]
    end

    it "should call config_file" do
      WatchTower::Config.expects(:config_file).returns(@config_path).once

      subject[:enabled]
    end

    it "should call YAML.parse_file" do
      Psych.expects(:parse_file).with(@config_path).returns(@yaml).once

      subject[:enabled]
    end

    it "should call to_ruby on the YAML result" do
      @yaml.expects(:to_ruby).returns(@config).once

      subject[:enabled]
    end

    it "should create a new HashWithIndifferentAccess" do
      HashWithIndifferentAccess.expects(:new).returns(@config).once

      subject[:enabled]
    end

    it "should raise ConfigNotDefinedError if config not found" do
      WatchTower::Config.stubs(:config_file).returns(nil)
      ::File.stubs(:exists?).with(@invalid_config_path).returns(false)

      -> { subject[:enabled] }.should raise_error ConfigNotDefinedError
    end

    it "should raise ConfigNotReadableError if config not found" do
      WatchTower::Config.stubs(:config_file).returns(@invalid_config_path)
      ::File.stubs(:readable?).with(@invalid_config_path).returns(false)

      -> { subject[:enabled] }.should raise_error ConfigNotReadableError
    end

    it "should handle the case where config is not a valid YAML file." do
      Psych.stubs(:parse_file).with(@config_path).returns(nil)

      -> { subject[:enabled] }.should raise_error ConfigNotValidError
    end

    it "should handle the case where :watch_tower key does not exist" do
      config = {}
      yaml = mock
      yaml.stubs(:to_ruby).returns(config)
      Psych.stubs(:parse_file).with(@config_path).returns(yaml)

      -> { subject[:enabled] }.should raise_error ConfigNotValidError
    end
  end
end
