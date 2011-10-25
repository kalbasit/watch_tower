# Sources
source "http://rubygems.org"

# Parse watch_tower.gemspec
gemspec

####
# For development or testing
###

# Require rbconfig to figure out the target OS
require 'rbconfig'

platforms :jruby do
  gem 'activerecord-jdbcmysql-adapter'
  gem 'activerecord-jdbcpostgresql-adapter'
  gem 'activerecord-jdbcsqlite3-adapter'
end

platforms :ruby do
  gem 'mysql2'
  gem 'sqlite3'

  unless ENV['TRAVIS']
    if RbConfig::CONFIG['target_os'] =~ /darwin/i
      gem 'rb-fsevent', require: false
      gem 'ruby-growl', require: false
      gem 'growl', require: false
    end
    if RbConfig::CONFIG['target_os'] =~ /linux/i
      gem 'rb-inotify', require: false
      gem 'libnotify', require: false
      gem 'therubyracer', require: false
    end
  end
end

platforms :mri do
  gem 'pg'
end
