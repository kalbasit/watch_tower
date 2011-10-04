require 'watch_tower/project/any_based'
require 'watch_tower/project/git_based'
require 'watch_tower/project/path_based'
require 'watch_tower/project/init'

module WatchTower
  class Project
    include AnyBased
    include Init
  end
end