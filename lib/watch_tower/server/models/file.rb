module WatchTower
  module Server
    class File < ::ActiveRecord::Base
      # Scopes
      default_scope order('files.elapsed_time DESC')
      scope :worked_on, -> { where('files.elapsed_time > ?', 0) }

      # Validations
      validates :project_id, presence: true
      validates :path, presence: true

      # Associations
      belongs_to :project, counter_cache: true
      has_many :time_entries, dependent: :destroy
      has_many :durations, dependent: :destroy
    end
  end
end