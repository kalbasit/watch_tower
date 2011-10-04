ROOT_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..'))
USER_PATH = File.expand_path(File.join(ENV['HOME'], '.watch_tower'))
DATABASE_PATH = File.join(USER_PATH, 'database')
LOG_PATH = File.join(USER_PATH, 'log')

# Make sure the USER_PATH exist
require 'fileutils'
FileUtils.mkdir_p USER_PATH
FileUtils.mkdir_p DATABASE_PATH
FileUtils.mkdir_p LOG_PATH

# Require daemon from active_support's core_ext allows us to fork really quickly
require 'active_support/core_ext/process/daemon'

# Require watch_tower's libraries
require "watch_tower/version"
require "watch_tower/core_ext"
require "watch_tower/cli"
require "watch_tower/editor"
require "watch_tower/project"
require "watch_tower/eye"
require "watch_tower/server"