# -*- encoding: utf-8 -*-

begin
  require 'appscript'
rescue LoadError
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
