require 'thor'
require 'watch_tower/cli/start'
require 'watch_tower/cli/install'

module WatchTower
  module CLI
    class Runner < ::Thor
      include ::Thor::Actions
      include Start
      include Install
    end
  end
end