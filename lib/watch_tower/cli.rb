# -*- encoding: utf-8 -*-

require 'thor'

# Load all modules
Dir["#{LIB_PATH}/cli/**/*.rb"].each { |f| require f }

module WatchTower
  module CLI
    class Runner < ::Thor
      # Include cli modules
      include Install
      include Open
      include Start
    end
  end
end