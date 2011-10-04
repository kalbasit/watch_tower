require 'watch_tower/cli/thor'
require 'watch_tower/cli/eye'

module WatchTower
  module CLI
    class Runner < ::Thor::Group
      include Eye
      include Thor
    end
  end
end