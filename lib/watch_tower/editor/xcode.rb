# -*- encoding: utf-8 -*-

module WatchTower
  module Editor
    class Xcode
      include BaseAppscript

      protected
        # This method returns an instance of ::Appscript::Application
        #
        # returns [::Appscript::Application | nil]
        def editor
          # Cannot use app('Xcode') because it fails when multiple Xcode versions are installed
          # Taken from timetap
          # https://github.com/apalancat/timetap/blob/editors/lib/time_tap/editors.rb#L25
          pid = app('System Events').processes[its.name.eq('Xcode')].first.unix_id.get
          app.by_pid(pid)
        rescue AppscriptNotLoadedError
          # This is expected if appscriot not loaded, on linux for example
        rescue ::FindApp::ApplicationNotFoundError
          LOG.debug "#{__FILE__}:#{__LINE__ - 5}: Xcode application can't be found, maybe not installed?"
          nil
        rescue ::Appscript::CommandError
          LOG.debug "#{__FILE__}:#{__LINE__ - 7}: Xcode is not running."
          nil
        end
    end
  end
end
