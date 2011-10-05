require 'git'

module WatchTower
  module Git
    extend self

    def active_for_path?(path)
      p = git_folder_path(path)
      p.present?
    end

    def base_path_for_path(path)
      git_folder_path(path)
    end

    def head(path)
      log(path)
    end

    def log(path)
      g = ::Git.open path
      g.log.first
    end

    protected
      def git_folder_path(path)
        # Define the start
        n = 0
        # Define the maximum search folder
        max_n = path.split('/').size

        until File.exists?(File.expand_path File.join(path, (%w{..} * n).flatten, '.git')) || n > max_n
          n = n + 1
        end

        if n <= max_n
          File.expand_path File.join(path, (%w{..} * n).flatten, '.git')
        else
          nil
        end
      end
  end
end