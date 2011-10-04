require 'watch_tower/project/init_based'
require 'watch_tower/project/git_based'
require 'watch_tower/project/path'

module WatchTower
  class Project
    include Init
  end
end