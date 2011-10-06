module WatchTower
  module Server
    class File < ::ActiveRecord::Base

      validates :project_id, presence: true
      validates :path, presence: true

      belongs_to :project, counter_cache: true
      has_many :time_entries, dependent: :destroy
    end
  end
end