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

      # Return the percent of this file
      def percent
        (elapsed_time * 100) / self.class.sum_elapsed_time
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