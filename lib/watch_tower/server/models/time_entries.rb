module WatchTower
  module Server
    class TimeEntries < ::ActiveRecord::Base
      validates :path, presence: true
      validates :mtime, presence: true
    end
  end
end