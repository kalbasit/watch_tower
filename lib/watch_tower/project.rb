require 'watch_tower/project/init'
require 'watch_tower/project/git_based'
require 'watch_tower/project/path_based'

module WatchTower
  class Project
    include Init
  end
end