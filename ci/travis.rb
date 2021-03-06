#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
# This file has been taken from rails
# https://github.com/rails/rails/blob/master/ci/travis.rb
require 'fileutils'
include FileUtils

commands = [
  'mysql -e "drop database if exists watch_tower_test;"',
  'mysql -e "create database watch_tower_test;"',
  'psql  -c "drop database if exists watch_tower_test;" -U postgres',
  'psql  -c "create database watch_tower_test;" -U postgres'
]

commands.each do |command|
  system("#{command} > /dev/null 2>&1")
end

class Build
  attr_reader :options

  def initialize(options = {})
    @options = options
  end

  def run!(options = {})
    self.options.update(options)
    create_config_file
    announce(heading)
    rake(*tasks)
  end

  def create_config_file
    commands = [
      "rm -rf ~/.watch_tower",
      "mkdir -p ~/.watch_tower",
      "cp lib/watch_tower/templates/config.yml ~/.watch_tower/config.yml",
      "cat ci/adapters/#{ruby_platform}-#{adapter}.yml >> ~/.watch_tower/config.yml"
    ]

    commands.each do |command|
      system("#{command}")
    end
  end

  def ruby_platform
    RUBY_PLATFORM == 'java' ? 'jruby' : 'ruby'
  end

  def announce(heading)
    puts "\n\e[1;33m[Travis CI] #{heading}\e[m\n"
  end

  def heading
    heading = [gem]
    heading << "with #{adapter}"
    heading.join(' ')
  end

  def tasks
    "spec"
  end

  def gem
    'watch_tower'
  end

  def adapter
    @options[:adapter]
  end

  def rake(*tasks)
    tasks.each do |task|
      cmd = "bundle exec rake #{task}"
      puts "Running command: #{cmd}"
      return false unless system(cmd)
    end
    true
  end
end

results = {}

ENV['ADAPTERS'].split(':').each do |adapter|
  # PG is not working on RBX
  # Probably a bug on Travis, to investigate of course
  if adapter == 'postgresql' && RUBY_ENGINE == 'rbx'
    results[adapter] = true
  else
    build = Build.new(adapter: adapter)
    results[adapter] = build.run!
  end
end

failures = results.select { |key, value| value == false }

if failures.empty?
  puts
  puts "WatchTower build finished sucessfully"
  exit(true)
else
  puts
  puts "WatchTower build FAILED"
  puts "Failed adapters: #{failures.keys.join(', ')}"
  exit(false)
end