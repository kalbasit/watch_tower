require 'watch_tower/project/any_based'
require 'watch_tower/project/init'

module WatchTower
  class Project
    extend ::ActiveSupport::Autoload

    autoload :GitBased
    autoload :PathBased

    include AnyBased
    include Init
  end
end