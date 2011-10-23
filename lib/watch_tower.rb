# -*- encoding: utf-8 -*-

# RubyGems is needed at first
require 'rubygems'

# Require daemon from active_support's core_ext allows us to fork really quickly
require 'active_support/core_ext/process/daemon'

# External requirements
require 'fileutils'
require 'logger'
require 'active_record'

# Define a few pathes
ROOT_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..'))
LIB_PATH = File.join(ROOT_PATH, 'lib', 'watch_tower')
SERVER_PATH = File.join(LIB_PATH, 'server')
MODELS_PATH = File.join(SERVER_PATH, 'models')
EXTENSIONS_PATH = File.join(SERVER_PATH, 'extensions')
MIGRATIONS_PATH = File.join(SERVER_PATH, 'db', 'migrate')
TEMPLATE_PATH = File.join(LIB_PATH, 'templates')
USER_PATH = File.expand_path(File.join(ENV['HOME'], '.watch_tower'))
DATABASE_PATH = File.join(USER_PATH, 'databases')
LOG_PATH = File.join(USER_PATH, 'log')

# Define the environment by default set to development
ENV['WATCH_TOWER_ENV'] ||= 'development'

# Make sure the USER_PATH exist
FileUtils.mkdir_p USER_PATH
FileUtils.mkdir_p DATABASE_PATH
FileUtils.mkdir_p LOG_PATH

# module WatchTower
module WatchTower

  # Create a logger
  LOG = Logger.new(File.join(LOG_PATH, "#{ENV['WATCH_TOWER_ENV']}.log"))

  # Threads
  # Hash
  @@threads = {}

  # Returh the threads
  #
  # @return [Hash] Threads
  def self.threads
    @@threads
  end

end

# Make sure we are running UTF-8
Encoding.default_external = 'utf-8'

# Require watch_tower's libraries
require "watch_tower/version"
require "watch_tower/errors"
require "watch_tower/core_ext"
require "watch_tower/config"
require "watch_tower/cli"
require "watch_tower/editor"
require "watch_tower/project"
require "watch_tower/eye"
require "watch_tower/file_tree"
require "watch_tower/server"