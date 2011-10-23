# -*- encoding: utf-8 -*-

module WatchTower
  module Server
    class Duration < ::ActiveRecord::Base
      validates :file_id, presence: true
      validates :date, presence: true
      validates :duration, presence: true

      belongs_to :file, counter_cache: true
    end
  end
end