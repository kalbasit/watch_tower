# -*- encoding: utf-8 -*-

module WatchTower
  module Server
    class Project < ::ActiveRecord::Base
      # Scopes
      default_scope order('projects.elapsed_time DESC')
      scope :worked_on, -> { where('projects.elapsed_time > ?', 0) }

      # Validations
      validates :name, presence: true
      validates :path, presence: true

      # Associations
      has_many :files, dependent: :destroy
      has_many :time_entries, through: :files
      has_many :durations, through: :files

      # Return the percent of this file
      def percent
        (elapsed_time * 100) / self.class.sum_elapsed_time
      end

      # Return an ActiveRelation limited to a date range
      #
      # @param [String] From date
      # @param [String] To date
      # @return [ActiveRelation]
      def self.date_range(from, to)
        from = Date.strptime(from, '%m/%d/%Y')
        to = Date.strptime(to, '%m/%d/%Y')

        joins(:durations => :file).
          where('durations.date >= ?', from).
          where('durations.date <= ?', to).
          select('DISTINCT projects.*')
      end

      # Returns the sum of all elapsed time
      #
      # @return [Integer]
      def self.sum_elapsed_time
        sum(:elapsed_time)
      end

      # Recalucate the elapsed time
      def recalculate_elapsed_time
        # Reset the elapsed_time of the project
        self.elapsed_time = 0
        # Save the project
        self.save!
        # Operate on all files
        files.each do |f|
          # Reset the elapsed_time of the files
          f.elapsed_time = 0
          # Save the file
          f.save!
          # Delete all durations
          f.durations.delete_all
          # Send calculate_elapsed_time to all time_entries ordered by
          # their id
          f.time_entries.order('id ASC').each do |t|
            t.send(:calculate_elapsed_time)
          end
        end
      end
    end
  end
end
