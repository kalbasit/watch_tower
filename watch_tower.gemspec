# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "watch_tower/version"

Gem::Specification.new do |s|
  s.name        = "watch_tower"
  s.version     = WatchTower::VERSION
  s.authors     = ["Wael Nasreddine"]
  s.email       = ["wael.nasreddine@gmail.com"]
  s.homepage    = ""
  s.summary     = "Unobtrusive time-tracking for TextMate."
  s.description = "TimeTap helps you track the time you spend coding on each project while in TextMate."

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")

  # Run-time dependencies
  s.add_dependency 'activesupport', '~>3.1.0'
  s.add_dependency 'activerecord', '~>3.1.0'
  s.add_dependency 'i18n', '~>0.6.0'
  s.add_dependency 'haml', '~>3.1.3'
  s.add_dependency 'sinatra', '~> 1.3.0'
  s.add_dependency 'git', '~>1.2.5'

  # Development dependencies
  s.add_development_dependency 'guard', '~>0.8.4'
  s.add_development_dependency 'guard-bundler', '~>0.1.3'
  s.add_development_dependency 'guard-rspec', '~>0.4.5'

  # Development / Test dependencies
  s.add_development_dependency 'rspec', '~>2.6.0'
  s.add_development_dependency 'rspec-rails', '~>2.6.1'
  s.add_development_dependency 'mocha', '~>0.10.0'
  s.add_development_dependency 'factory_girl', '~>2.1.2'
  s.add_development_dependency 'timecop', '~>0.3.5'
  s.add_development_dependency 'capybara', '~>1.1.1'

  # Debugging
  s.add_development_dependency 'pry', '~>0.9.6.2'
end