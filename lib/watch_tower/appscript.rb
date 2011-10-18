begin
  require 'rubygems'
  require 'appscript'
rescue LoadError
  require 'rbconfig'
  if RbConfig::CONFIG['target_os'] =~ /darwin/i
    STDERR.puts "Please install 'appscript' to use this gem with Textmate"
    STDERR.puts "gem install appscript"
  end

  # Define a part of the Appscript gem so WatchTower is fully operational
  module ::Appscript
    CommandError = Class.new(Exception)

    class Application

      MOCK_METHODS = [:name, :version, :unix_id, :by_pid]

      def is_running?
        false
      end

      def get
        "Not available"
      end

      def processes
        Process.new(self)
      end

      MOCK_METHODS.each do |method|
        define_method method do |*args|
          self
        end
      end
    end

    class Process
      def initialize(klass)
        @klass = klass
      end

      def [](*args)
        [@klass]
      end
    end

    def app(*args)
      Application.new
    end

    def its
      self
    end

    def name
      self
    end

    def eq(*args)
      self
    end

    def Appscript.app(*args)
      Application.new
    end

    def Appscript.its
      self
    end

    def Appscript.name
      self
    end

    def Appscript.eq(*args)
      self
    end

  end

  module ::FindApp
    ApplicationNotFoundError = Class.new(Exception)
  end
end