require 'watch_tower/cli/thor'

module WatchTower
  module CLI
    class Runner < ::Thor::Group
      include Thor
    end
  end
end