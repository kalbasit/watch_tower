module WatchTower
  module Server
    class TimeEntry < ::ActiveRecord::Base
      validates :file_id, presence: true
      validates :mtime, presence: true

      belongs_to :file, counter_cache: true

    end
  end
end