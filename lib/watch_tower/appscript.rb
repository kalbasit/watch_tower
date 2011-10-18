begin
  require 'rubygems'
  require 'appscript'
rescue LoadError
  require 'rbconfig'
  if RbConfig::CONFIG['target_os'] =~ /darwin/i
    STDERR.puts "Please install 'appscript' to use this gem with Textmate"
    STDERR.puts "gem install appscript"
  end
  # Define a simple class so the gem works even if Appscript is not installed
  module ::Appscript
    class Application
      def is_running?
        false
      end

      def name
        "Not available"
      end

      def version
        "Not available"
      end
    end

    def app(*args)
      Application.new
    end
  end
end