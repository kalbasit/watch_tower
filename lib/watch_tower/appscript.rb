# -*- encoding: utf-8 -*-

begin
  require 'rubygems'
  require 'appscript'
rescue LoadError
  require 'rbconfig'
  if RbConfig::CONFIG['target_os'] =~ /darwin/i
    STDERR.puts "Please install 'appscript' to use this gem with Textmate"
    STDERR.puts "gem install appscript"
  end

  # Define a part of the Appscript gem so WatchTower is fully operational
  module ::Appscript
    CommandError = Class.new(Exception)
    def app(*args)
      raise ::WatchTower::AppscriptNotLoadedError
    end
  end

  module ::FindApp
    ApplicationNotFoundError = Class.new(Exception)
  end
end
