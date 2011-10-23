module WatchTower
  module CLI
    module Install

      def self.included(base)
        base.send :include, InstanceMethods
      end

      module InstanceMethods
        def self.included(base)
          base.class_eval <<-END, __FILE__, __LINE__ + 1
            # This module needs Thor::Actions
            include ::Thor::Actions

            # Mappings (aliases)
            map "-i" => :install

            # Install WatchTower
            desc "install", "Install Watch Tower"
            def install
              # Install the configuration file
              install_config_file
              # Install the bootloader
              install_bootloader
            end

            protected
              # Taken from hub
              # https://github.com/defunkt/hub/blob/master/lib/hub/context.rb#L186
              # Cross-platform way of finding an executable in the $PATH.
              #
              # which('ruby') #=> /usr/bin/ruby
              def which(cmd)
                exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
                ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
                  exts.each { |ext|
                    exe = "\#{path}/\#{cmd}\#{ext}"
                    return exe if File.executable? exe
                  }
                end
                return nil
              end

              # Install the configuration file
              def install_config_file
                self.class.source_root(TEMPLATE_PATH)
                copy_file 'config.yml', File.join(USER_PATH, 'config.yml')
              end

              # Install bootloader
              def install_bootloader
                require 'rbconfig'
                case RbConfig::CONFIG['target_os']
                when /darwin/
                  install_bootloader_on_mac
                else
                  puts <<-MSG
WatchTower bootloader is not supported on your OS, you'd have to run it manually
for the time being. Support for many editors and many OSes is planned for the
future, if you would like to help, or drop in an issue please don't hesitate to
do so on the project's Github page: https://github.com/TechnoGate/watch_tower
MSG
                end
              end

              # Install bootloader on Mac OS X
              def install_bootloader_on_mac
                self.class.source_root(TEMPLATE_PATH)
                # copy_file 'watchtower.plist', File.join(ENV['HOME'], 'Library',
                #   'LaunchAgents', 'fr.technogate.WatchTower.plist')
                create_file File.join(ENV['HOME'], 'Library', 'LaunchAgents', 'fr.technogate.WatchTower.plist') do
                  ruby_binary = which('ruby')
                  watch_tower_binary = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'bin', 'watchtower'))
                  template = File.expand_path(find_in_source_paths('watchtower.plist.erb'))
                  ERB.new(File.read(template)).result(binding)
                end

                puts "\nCreated. Now run:\n  launchctl load ~/Library/LaunchAgents/fr.technogate.WatchTower.plist\n\n"
              end
          END
        end
      end
    end
  end
end