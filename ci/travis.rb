#!/usr/bin/env ruby
# This file has been taken from rails
# https://github.com/rails/rails/blob/master/ci/travis.rb
require 'fileutils'
include FileUtils

commands = [
  'mysql -e "create database watch_tower_test;"',
  'psql  -c "create database watch_tower_test;" -U postgres',
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
    announce(heading)
    rake(*tasks)
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

ENV['ADAPTER'].each do |adapter|
  build = Build.new(adapter: adapter)
  results[adapter] = build.run!
end

failures = results.select { |key, value| value == false }

if failures.empty?
  puts
  puts "WatchTower build finished sucessfully"
  exit(true)
else
  puts
  puts "WatchTower build FAILED"
  puts "Failed adapters: #{failures.join(', ')}"
  exit(false)
end