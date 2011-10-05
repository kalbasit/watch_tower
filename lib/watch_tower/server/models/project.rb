module WatchTower
  module Server
    class Project < ::ActiveRecord::Base
      validates :name, presence: true
      validates :path, presence: true

      has_many :files, dependent: :destroy
      has_many :time_entries, through: :files
    end
  end
end