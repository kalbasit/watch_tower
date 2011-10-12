module WatchTower
  module Server
    module Presenters
      extend ::ActiveSupport::Autoload

      autoload :ApplicationPresenter
      autoload :ProjectPresenter
      autoload :FilePresenter
    end
  end
end