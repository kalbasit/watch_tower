source "http://rubygems.org"

# Specify your gem's dependencies in watch_tower.gemspec
gemspec

# Databases
# Defined here so they will be used only in development/test mode
platforms :ruby do
  gem 'mysql2'
  unless ENV['TRAVIS']
    gem 'pg'
  end
  gem 'sqlite3'
end

platforms :jruby do
  gem 'activerecord-jdbcmysql-adapter'
  gem 'activerecord-jdbcpostgresql-adapter'
  gem 'activerecord-jdbcsqlite3-adapter'
end

platforms :ruby do
  # Require rbconfig to figure out the target OS
  require 'rbconfig'

  unless ENV['TRAVIS']
    if RbConfig::CONFIG['target_os'] =~ /darwin/i
      gem 'rb-fsevent', require: false
      gem 'ruby-growl', require: false
      gem 'growl', require: false
      gem 'rb-appscript', '~>0.6.1'
    end
    if RbConfig::CONFIG['target_os'] =~ /linux/i
      gem 'rb-inotify', require: false
      gem 'libnotify', require: false
    end
  end
end