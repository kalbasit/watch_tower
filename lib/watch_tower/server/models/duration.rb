# -*- encoding: utf-8 -*-

module WatchTower
  module Server
    class Duration < ::ActiveRecord::Base
      # Scopes
      scope :before_date, lambda { |date| where('date <= ?', Date.strptime(date, '%m/%d/%Y')) }
      scope :after_date, lambda { |date| where('date >= ?', Date.strptime(date, '%m/%d/%Y')) }
      scope :date_range, lambda { |from, to| after_date(from).before_date(to) }

      # Validations
      validates :file_id, presence: true
      validates :date, presence: true
      validates :duration, presence: true

      # Associations
      belongs_to :file, counter_cache: true
    end
  end
end