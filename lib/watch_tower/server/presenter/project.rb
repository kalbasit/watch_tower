module WatchTower
  module Server
    module Presenter
      class Project
        include Base

        # Returns a human formatted time
        #
        # @return [String] The elapsed time formatted
        def elapsed
          humanize_time elapsed_time
        end
      end
    end
  end
end