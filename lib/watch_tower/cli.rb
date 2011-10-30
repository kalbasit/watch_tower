# -*- encoding: utf-8 -*-

require 'thor'

# Load all modules
Dir["#{LIB_PATH}/cli/**/*.rb"].each { |f| require f }

module WatchTower
  module CLI
    class Runner < ::Thor
      # Include cli modules
      include CLI::Version
      include CLI::Install
      include CLI::Open
      include CLI::Start
    end
  end
end
