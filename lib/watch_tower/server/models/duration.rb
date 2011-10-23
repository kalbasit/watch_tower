# -*- encoding: utf-8 -*-

module WatchTower
  module Server
    class Duration < ::ActiveRecord::Base
      validates :file_id, presence: true
      validates :date, presence: true
      validates :duration, presence: true

      belongs_to :file, counter_cache: true

      # Return an ActiveRelation limited to a date range
      #
      # @param [String] From date
      # @param [String] To date
      # @return [ActiveRelation]
      def self.date_range(from, to)
        from = Date.strptime(from, '%m/%d/%Y')
        to = Date.strptime(to, '%m/%d/%Y')

        where('date >= ?', from).
          where('date <= ?', to)
      end
    end
  end
end