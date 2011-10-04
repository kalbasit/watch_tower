begin
  require 'sqlite3'
rescue LoadError => e
  if ENV['TRAVIS']
    # Travis hates sqlite with Jruby so it is disabled
  else
    raise LoadError, e
  end
end

require 'active_record'

module WatchTower
  class TimeEntries < ::ActiveRecord::Base
  end
end