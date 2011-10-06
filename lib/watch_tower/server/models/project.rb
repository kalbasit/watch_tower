module WatchTower
  module Server
    class Project < ::ActiveRecord::Base
      # Scopes
      default_scope order('projects.elapsed_time DESC')

      # Validations
      validates :name, presence: true
      validates :path, presence: true

      # Associations
      has_many :files, dependent: :destroy
      has_many :time_entries, through: :files
    end
  end
end