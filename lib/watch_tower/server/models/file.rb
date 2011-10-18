module WatchTower
  module Server
    class File < ::ActiveRecord::Base
      # Scopes
      default_scope order('files.elapsed_time DESC')
      scope :worked_on, -> { where('files.elapsed_time > ?', 0) }

      # Validations
      validates :project_id, presence: true
      validates :path, presence: true
      validates_uniqueness_of :path, sope: :project_id

      # Associations
      belongs_to :project, counter_cache: true
      has_many :time_entries, dependent: :destroy
      has_many :durations, dependent: :destroy

      # Return the percent of this file
      def percent
        (elapsed_time * 100) / project.files.sum_elapsed_time
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
          select('DISTINCT "files".*')
      end

      # Returns the sum of all elapsed time
      #
      # @return [Integer]
      def self.sum_elapsed_time
        sum(:elapsed_time)
      end
    end
  end
end